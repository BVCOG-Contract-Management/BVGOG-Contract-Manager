# frozen_string_literal: true

# Contract Controller
class ContractsController < ApplicationController
    before_action :set_contract, only: %i[show edit update]

    def expiry_reminder
        @contract = Contract.find(params[:id])
        respond_to do |format|
            # If contract already expired, redirect to contract show page
            if @contract.expired?
                format.html { redirect_to contract_url(@contract), alert: 'Contract has already expired.' }
                format.json do
                    render json: { error: 'Contract has already expired.' }, status: :unprocessable_entity
                end
            else
                @contract.send_expiry_reminder
                format.html { redirect_to contract_url(@contract), notice: 'Expiry reminder sucessfully sent.' }
                format.json { render :show, status: :ok, location: @contract }
            end
        end
    end

    # GET /contracts or /contracts.json
    def index
        add_breadcrumb 'Contracts', contracts_path
        # Sort contracts
        @contracts = sort_contracts.page params[:page]
        # Filter contracts based on allowed entities if user is level 3
        @contracts = @contracts.where(entity_id: current_user.entities.pluck(:id)) if current_user.level != UserLevel::ONE
        # Search contracts
        @contracts = search_contracts(@contracts) if params[:search].present?
    end

    # GET /contracts/1 or /contracts/1.json
    def show
        begin
            OSO.authorize(current_user, 'read', @contract)
        rescue Oso::Error
            redirect_to root_path, alert: 'You do not have permission to access this page.'
            return
        end
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb @contract.title, contract_path(@contract)

        @decisions = @contract.decisions.order(created_at: :asc)
    end

    # GET /contracts/new
    def new
        if current_user.level == UserLevel::TWO
            redirect_to root_path, alert: 'You do not have permission to access this page.'
            return
        end
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb 'New Contract', new_contract_path
        @contract = Contract.new
    end

    # GET /contracts/1/edit
    def edit
        if current_user.level == UserLevel::TWO
            redirect_to root_path, alert: 'You do not have permission to access this page.'
            return
        end
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb @contract.title, contract_path(@contract)
        add_breadcrumb 'Edit', edit_contract_path(@contract)
    end

    # POST /contracts or /contracts.json
    def create
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb 'New Contract', new_contract_path

        contract_documents_upload = params[:contract][:contract_documents]
        contract_documents_attributes = params[:contract][:contract_documents_attributes]
        # Delete the contract_documents from the params
        # so that it doesn't get saved as a contract attribute
        params[:contract].delete(:contract_documents)
        params[:contract].delete(:contract_documents_attributes)
        params[:contract].delete(:contract_document_type_hidden)

        contract_params_clean = contract_params
        contract_params_clean.delete(:new_vendor_name)

        @contract = Contract.new(contract_params_clean.merge(contract_status: ContractStatus::IN_PROGRESS))

        respond_to do |format|
            ActiveRecord::Base.transaction do
                begin
                    OSO.authorize(current_user, 'write', @contract)
                    handle_if_new_vendor

                    #  Check specific for PoC since we use it down the line to check entity association
                    if contract_params[:point_of_contact_id].blank?
                        @contract.errors.add(:base, 'Point of contact is required')
                        format.html { render :new, status: :unprocessable_entity }
                        format.json { render json: @contract.errors, status: :unprocessable_entity }
                    elsif @contract.point_of_contact_id.present? && !User.find(@contract.point_of_contact_id).is_active
                        if User.find(@contract.point_of_contact_id).redirect_user_id.present?
                            @contract.errors.add(:base,
                                                 "#{User.find(@contract.point_of_contact_id).full_name} is not active, use #{User.find(User.find(@contract.point_of_contact_id).redirect_user_id).full_name} instead")
                        else
                            @contract.errors.add(:base,
                                                 "#{User.find(@contract.point_of_contact_id).full_name} is not active")
                        end
                        format.html { render :new, status: :unprocessable_entity }
                        format.json { render json: @contract.errors, status: :unprocessable_entity }
                    elsif User.find(@contract.point_of_contact_id).level == UserLevel::THREE && !User.find(@contract.point_of_contact_id).entities.include?(@contract.entity)
                        @contract.errors.add(:base,
                                             "#{User.find(@contract.point_of_contact_id).full_name} is not associated with #{@contract.entity.name}")
                        format.html { render :new, status: :unprocessable_entity }
                        format.json { render json: @contract.errors, status: :unprocessable_entity }
                    elsif @contract.save
                        @decision = @contract.decisions.build(decision: ContractStatus::CREATED, user: current_user)
                        @decision.save
                        @decision = @contract.decisions.build(decision: ContractStatus::IN_PROGRESS, user: current_user)
                        @decision.save
                        if contract_documents_upload.present?
                            handle_contract_documents(contract_documents_upload,
                                                      contract_documents_attributes)
                        end
                        format.html do
                            redirect_to contract_url(@contract), notice: 'Contract was successfully created.'
                        end
                        format.json { render :show, status: :created, location: @contract }
                    else
                        format.html { render :new, status: :unprocessable_entity }
                        format.json { render json: @contract.errors, status: :unprocessable_entity }
                    end
                end
            rescue StandardError => e
                # If error type is Oso::ForbiddenError, then the user is not authorized
                if e.instance_of?(Oso::ForbiddenError)
                    # status = :unauthorized
                    @contract.errors.add(:base, 'You are not authorized to create a contract')
                    message = 'You are not authorized to create a contract'
                else
                    # status = :unprocessable_entity
                    message = e.message
                end
                format.html { redirect_to contracts_path, alert: message }
            end
        end
    end

    # def review
    #     @contract = Contract.find(params[:id])
    #     add_breadcrumb 'Contracts', contracts_path
    #     add_breadcrumb @contract.title, contract_path(@contract)
    #     add_breadcrumb 'Review', review_contract_path(@contract)

    #     respond_to do |format|
    #         ActiveRecord::Base.transaction do
    #             OSO.authorize(current_user, 'review', @contract)
    #             case params[:action]
    #             when 'submit'
    #                 handle_submit_action(format)
    #             when 'approve'
    #                 handle_approve_action(format)
    #             when 'return'
    #                 handle_return_action(format)
    #             else
    #                 format.html { redirect_to contract_url(@contract), alert: 'Invalid action.' }
    #             end
    #         end
    #     rescue StandardError
    #         handle_error(format)
    #     end
    # end

    # def handle_submit_action(format)
    #     # Your logic for handling the submission action
    #     @contract.update(contract_status: ContractStatus::IN_REVIEW)
    #     format.html { redirect_to contract_url(@contract), notice: 'Contract submitted successfully.' }
    #     format.json { render :show, status: :ok, location: @contract }
    # end

    # def handle_approve_action(format)
    #     status = case @contract.contract_status
    #              when ContractStatus::IN_PROGRESS
    #                  ContractStatus::APPROVED
    #              when ContractStatus::APPROVED
    #                  ContractStatus::IN_PROGRESS
    #              else
    #                  ContractStatus::IN_PROGRESS
    #              end
    #     @contract.update(contract_status: status)
    #     format.html { redirect_to contract_url(@contract), notice: 'Contract approved successfully.' }
    #     format.json { render :show, status: :ok, location: @contract }
    # end

    # def handle_return_action(format)
    #     @contract.update(contract_status: ContractStatus::IN_PROGRESS)
    #     format.html { redirect_to contract_url(@contract), notice: 'Contract set to "In Progress".' }
    #     format.json { render :show, status: :ok, location: @contract }
    # end

    # def handle_error(format)
    #     message = 'You do not have permission to perform this action on the contract.'
    #     format.html { redirect_to contract_url(@contract), alert: message }
    #     format.json { render json: { error: message }, status: :unauthorized }
    # end

    # PATCH/PUT /contracts/1 or /contracts/1.json
    def update
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb @contract.title, contract_path(@contract)
        add_breadcrumb 'Edit', edit_contract_path(@contract)

        handle_if_new_vendor
        # Remove the new vendor from the params
        params[:contract].delete(:new_vendor_name)
        contract_documents_upload = params[:contract][:contract_documents]
        contract_documents_attributes = params[:contract][:contract_documents_attributes]
        # Delete the contract_documents from the params
        # so that it doesn't get saved as a contract attribute
        params[:contract].delete(:contract_documents)
        params[:contract].delete(:contract_documents_attributes)
        params[:contract].delete(:contract_document_type_hidden)

        respond_to do |format|
            ActiveRecord::Base.transaction do
                OSO.authorize(current_user, 'edit', @contract)
                if @contract[:point_of_contact_id].blank? && contract_params[:point_of_contact_id].blank?
                    @contract.errors.add(:base, 'Point of contact is required')
                    format.html { render :edit, status: :unprocessable_entity }
                    format.json { render json: @contract.errors, status: :unprocessable_entity }
                elsif contract_params[:point_of_contact_id].present? && !User.find(contract_params[:point_of_contact_id]).is_active
                    if User.find(contract_params[:point_of_contact_id]).redirect_user_id.present?
                        @contract.errors.add(:base,
                                             "#{User.find(contract_params[:point_of_contact_id]).full_name} is not active, use #{User.find(User.find(contract_params[:point_of_contact_id]).redirect_user_id).full_name} instead")
                    else
                        @contract.errors.add(:base,
                                             "#{User.find(contract_params[:point_of_contact_id]).full_name} is not active")
                    end
                    format.html { render :edit, status: :unprocessable_entity }
                    format.json { render json: @contract.errors, status: :unprocessable_entity }

                # Excuse this monster if statement, it's just checking if the user is associated with the entity, and for
                # some reason nested-if statements don't work here when you use format (ie. UnkownFormat error)
                elsif contract_params[:point_of_contact_id].present? && User.find(contract_params[:point_of_contact_id]).level == UserLevel::THREE && !User.find(contract_params[:point_of_contact_id]).entities.include?(Entity.find((contract_params[:entity_id].presence || @contract.entity_id)))
                    @contract.errors.add(:base,
                                         "#{User.find((contract_params[:point_of_contact_id].presence || @contract.point_of_contact_id)).full_name} is not associated with #{Entity.find((contract_params[:entity_id].presence || @contract.entity_id)).name}")
                    format.html { render :edit, status: :unprocessable_entity }
                    format.json { render json: @contract.errors, status: :unprocessable_entity }
                elsif @contract.update(contract_params)
                    if contract_documents_upload.present?
                        handle_contract_documents(contract_documents_upload,
                                                  contract_documents_attributes)
                    end
                    format.html do
                        redirect_to contract_url(@contract), notice: 'Contract was successfully updated.'
                    end
                    format.json { render :show, status: :ok, location: @contract }
                else
                    format.html { render :edit, status: :unprocessable_entity }
                    format.json { render json: @contract.errors, status: :unprocessable_entity }
                end
            end
        rescue StandardError => e
            @contract.reload
            # If error type is Oso::ForbiddenError, then the user is not authorized
            if e.instance_of?(Oso::ForbiddenError)
                # status = :unauthorized
                @contract.errors.add(:base, 'You are not authorized to update this contract')
                message = 'You are not authorized to update this contract'
            else
                # status = :unprocessable_entity
                message = e.message
            end
            # Rollback the transaction
            format.html { redirect_to contract_url(@contract), alert: message }
        end
    end

    def contract_files
        contract_document = ContractDocument.find(params[:id])
        send_file contract_document.file.path, type: contract_document.file_content_type, disposition: :inline
    end

    def reject
        @contract = Contract.find(params[:id])
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb @contract.title, contract_path(@contract)
        add_breadcrumb 'Reject', reject_contract_path(@contract)
    end

    def log_rejection
        ActiveRecord::Base.transaction do
            @contract = Contract.find(params[:contract_id])
            reason = params[:contract][:rejection_reason]

            @contract.update(contract_status: ContractStatus::REJECTED)
            @decision = @contract.decisions.build(reason:, decision: ContractStatus::REJECTED, user: current_user)
            if @decision.save
                redirect_to contract_url(@contract.id), notice: 'Contract was Rejected.'
            else
                redirect_to contract_url(@contract.id), alert: 'Contract Rejection failed.'
            end
        end
    end

    def log_approval
        ActiveRecord::Base.transaction do
            @contract = Contract.find(params[:contract_id])
            @contract.update(contract_status: ContractStatus::APPROVED)
            @decision = @contract.decisions.build(reason: nil, decision: ContractStatus::APPROVED, user: current_user)
            @decision.save
            redirect_to contract_url(@contract.id), notice: 'Contract was Approved.'
        end
    end

    def log_return
        ActiveRecord::Base.transaction do
            @contract = Contract.find(params[:contract_id])
            @contract.update(contract_status: ContractStatus::IN_PROGRESS)
            @decision = @contract.decisions.build(reason: nil, decision: ContractStatus::IN_PROGRESS,
                                                  user: current_user)
            @decision.save
            redirect_to contract_url(@contract.id), notice: 'Contract was returned to In Progress.'
        end
    end

    def log_submission
        ActiveRecord::Base.transaction do
            @contract = Contract.find(params[:contract_id])
            @contract.update(contract_status: ContractStatus::IN_REVIEW)
            @decision = @contract.decisions.build(reason: nil, decision: ContractStatus::IN_REVIEW, user: current_user)
            @decision.save
            redirect_to contract_url(@contract.id), notice: 'Contract was Submitted.'
        end
    end

    # Only allow a list of trusted parameters through.
    def contract_params
        allowed = %i[
            title
            description
            key_words
            starts_at
            ends_at
            ends_at_final
            contract_status
            entity_id
            program_id
            point_of_contact_id
            vendor_id
            amount_dollar
            amount_duration
            initial_term_amount
            initial_term_duration
            end_trigger
            contract_type
            requires_rebid
            number
            new_vendor_name
            contract_documents
            contract_documents_attributes
            contract_document_type_hidden
            renewal_count
            max_renewal_count
            renewal_duration
            renewal_duration_units
            extension_count
            max_extension_count
            extension_duration
            extension_duration_units
        ]
        params.require(:contract).permit(allowed)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_contract
        @contract = Contract.find(params[:id])
    end

    def set_users
        @users = User.all
    end

    def sort_contracts
        # Sorts by the query string parameter "sort"
        # Since some columns are combinations or associations, we need to handle them separately
        asc = params[:order] || 'asc'
        case params[:sort]
        when 'point_of_contact'
            # Sort by the name of the point of contact
            Contract.joins(:point_of_contact).order("users.last_name #{asc}").order("users.first_name #{asc}")
        when 'vendor'
            Contract.joins(:vendor).order("vendors.name #{asc}")
        else
            begin
                # Sort by the specified column and direction
                params[:sort] ? Contract.order(params[:sort] => asc.to_sym) : Contract.order(created_at: :asc)
            rescue ActiveRecord::StatementInvalid
                # Otherwise, sort by title
                # TODO: should we reconsider this?
                Contract.order(title: :asc)
            end
        end

        # Returns the sorted contracts
    end

    def search_contracts(contracts)
        # Search by the query string parameter "search"
        # Search in "title", "description", and "key_words"
        contracts.where('title LIKE ? OR description LIKE ? OR key_words LIKE ?', "%#{params[:search]}%",
                        "%#{params[:search]}%", "%#{params[:search]}%")
    end

    def handle_if_new_vendor
        # Check if the vendor is new
        if params[:contract][:vendor_id] == 'new'
            # Create a new vendor

            # Make vendor name Name Case
            params[:contract][:new_vendor_name] = params[:contract][:new_vendor_name].titlecase
            vendor = Vendor.new(name: params[:contract][:new_vendor_name])
            # If the vendor is saved successfully
            if vendor.save
                # Set the contract's vendor to the new vendor
                @contract.vendor = vendor
            end
        end
        # Remove the new_vendor_name parameter
        params[:contract].delete(:new_vendor_name)
    end

    # TODO: This is a temporary solution
    # File upload is a seperate issue that will be handled with a dropzone
    def handle_contract_documents(contract_documents_upload, contract_documents_attributes)
        contract_documents_upload.each do |doc|
            next if doc.blank?

            # Create a file name for the official file
            official_file_name = contract_document_filename(@contract, File.extname(doc.original_filename))
            # Write the file to the if the contract does not have
            # a contract_document with the same orig_file_name
            next if @contract.contract_documents.find_by(orig_file_name: doc.original_filename)

            # Write the file to the filesystem
            bvcog_config = BvcogConfig.last
            File.open(File.join(bvcog_config.contracts_path, official_file_name), 'wb') do |file|
                file.write(doc.read)
            end
            # Get document type
            document_type = contract_documents_attributes[doc.original_filename][:document_type] || ContractDocumentType::OTHER
            # Create a new contract_document
            contract_document = ContractDocument.new(
                orig_file_name: doc.original_filename,
                file_name: official_file_name,
                full_path: File.join(bvcog_config.contracts_path, official_file_name).to_s,
                document_type:
            )
            # Add the contract_document to the contract
            @contract.contract_documents << contract_document
        end
    end
end

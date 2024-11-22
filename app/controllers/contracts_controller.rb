# frozen_string_literal: true

class ContractsController < ApplicationController
    before_action :set_contract, only: %i[show edit update]

    # Standard Actions
    # GET /contracts or /contracts.json
    def index
        add_breadcrumb 'Contracts', contracts_path
        # Sort contracts
        @contracts = sort_contracts.page params[:page]
        # Filter contracts based on allowed entities if user is level 3
        @contracts = @contracts.where(entity_id: current_user.entities.pluck(:id)) if current_user.level != UserLevel::ONE
        # Search contracts
        @contracts = search_contracts(@contracts) if params[:search].present?
        Rails.logger.debug params[:search].inspect
    end

    # GET /contracts/modify
    def modify
        add_breadcrumb 'Contracts', modify_contracts_path
        # Sort contracts
        @contracts = sort_contracts.page params[:page]
        # Filter contracts based on allowed entities if user is level 3
        @contracts = @contracts.where(entity_id: current_user.entities.pluck(:id)) if current_user.level != UserLevel::ONE
        @contracts = @contracts.where(contract_status: ContractStatus::APPROVED)
        # Search contracts
        @contracts = search_contracts(@contracts) if params[:search].present?
        Rails.logger.debug params[:search].inspect
    end


    # GET /contracts/1 or /contracts/1.json
    def show
        begin
            OSO.authorize(current_user, 'read', @contract)
        rescue Oso::Error
            # :nocov:
            redirect_to root_path, alert: 'You do not have permission to access this page.'
            return
            # :nocov:
        end
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb @contract.title, contract_path(@contract)

        @modify = '123'

        @decisions = @contract.decisions.order(created_at: :asc)
        # :nocov:
        @modification_logs = @contract.modification_logs.order(created_at: :desc)
        # :nocov:
    end

    # GET /contracts/new
    def new
        if current_user.level == UserLevel::TWO
            # :nocov:
            redirect_to root_path, alert: 'You do not have permission to access this page.'
            return
            # :nocov:
        end
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb 'New Contract', new_contract_path

        @vendor_visible_id = ''
        @value_type = ''
        @contract = Contract.new
    end

    # GET /contracts/1/edit
    def edit
        action = case
            when request.path == amend_contract_path(@contract)
                "amend"
            else
                "edit"
            end
        begin
            OSO.authorize(current_user, action, @contract)
        rescue Oso::Error
            # :nocov:
            redirect_to root_path, alert: 'You do not have permission to access this page.'
            return
            # :nocov:
        end

        case @contract.current_type
        when 'contract'
            if request.path == amend_contract_path(@contract)
                render 'amend'
            else
                render 'edit'
            end

            add_breadcrumb 'Contracts', contracts_path
            add_breadcrumb @contract.title, contract_path(@contract)
            vendor = Vendor.find_by(id: @contract.vendor_id)
            vendor_name = vendor.name if vendor.present? || ''

            @vendor_visible_id = vendor_name || ''
            add_breadcrumb 'Edit', edit_contract_path(@contract)
            @value_type = @contract.value_type
            @funding_source_selected = @contract.funding_source.presence || ''
            @hidden_funding_source = ''
        when 'amend'
            render 'amend'
            # when 'renew'
            #     render 'renew'
        end
    end

    # GET /contracts/1/renew
    def renew
        if current_user.level == UserLevel::TWO
            # :nocov:
            redirect_to root_path, alert: 'You do not have permission to access this page.'
            return
            # :nocov:
        end
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb @contract.title, contract_path(@contract)
        vendor = Vendor.find_by(id: @contract.vendor_id)
        vendor_name = vendor.name if vendor.present? || ''

        @vendor_visible_id = vendor_name || ''
        add_breadcrumb 'Renew', edit_contract_path(@contract)
        @value_type = @contract.value_type
    end

    # POST /contracts or /contracts.json
    def create
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb 'New Contract', new_contract_path

        contract_documents_upload = params[:contract][:contract_documents]
        contract_documents_attributes = params[:contract][:contract_documents_attributes]
        value_type_selected = params[:contract][:value_type]
        vendor_selection = params[:vendor_visible_id]
        funding_source_selected = params[:contract][:funding_source]
        params[:contract][:new_funding_source]
        # Delete the contract_documents from the params
        #         # so that ie t doesn't get saved as a contract attribute
        params[:contract].delete(:contract_documents)
        params[:contract].delete(:contract_documents_attributes)
        params[:contract].delete(:contract_document_type_hidden)
        params[:contract].delete(:vendor_visible_id)

        contract_params_clean = contract_params
        contract_params_clean.delete(:new_vendor_name)
        contract_params_clean.delete(:new_funding_source)

        @contract = Contract.new(contract_params_clean.merge(contract_status: ContractStatus::IN_PROGRESS))

        respond_to do |format|
            ActiveRecord::Base.transaction do
                begin
                    OSO.authorize(current_user, 'write', @contract)
                    handle_if_new_vendor
                    handle_if_new_funding_source

                    #  Check specific for PoC since we use it down the line to check entity association
                    if contract_params[:point_of_contact_id].blank?
                        # :nocov:
                        @contract.errors.add(:base, 'Point of contact is required')
                        format.html do
                            # to retain the value of the vendor dropdown and value type dropdown after validation error
                            retain_dropdown_values(value_type_selected, vendor_selection, funding_source_selected)

                            render :new, status: :unprocessable_entity
                        end
                        format.json { render json: @contract.errors, status: :unprocessable_entity }
                        # :nocov:
                    elsif @contract.point_of_contact_id.present? && !User.find(@contract.point_of_contact_id).is_active
                        # :nocov:
                        if User.find(@contract.point_of_contact_id).redirect_user_id.present?
                            @contract.errors.add(:base,
                                                 "#{User.find(@contract.point_of_contact_id).full_name} is not active, use #{User.find(User.find(@contract.point_of_contact_id).redirect_user_id).full_name} instead")
                        else
                            @contract.errors.add(:base,
                                                 "#{User.find(@contract.point_of_contact_id).full_name} is not active")
                        end
                        format.html do
                            # to retain the value of the vendor dropdown and value type dropdown after validation error
                            retain_dropdown_values(value_type_selected, vendor_selection, funding_source_selected)

                            render :new, status: :unprocessable_entity
                        end
                        # format.html { render :new, status: :unprocessable_entity, session[:value_type] = params[:contract][:value_type] }

                        format.json { render json: @contract.errors, status: :unprocessable_entity }
                        # :nocov:
                    elsif User.find(@contract.point_of_contact_id).level == UserLevel::THREE && !User.find(@contract.point_of_contact_id).entities.include?(@contract.entity)
                        # :nocov:
                        @contract.errors.add(:base,
                                             "#{User.find(@contract.point_of_contact_id).full_name} is not associated with #{@contract.entity.name}")
                        # format.html { render :new, status: :unprocessable_entity,, session[:value_type] = params[:contract][:value_type] }
                        format.html do
                            # to retain the value of the vendor dropdown and value type dropdown after validation error
                            retain_dropdown_values(value_type_selected, vendor_selection, funding_source_selected)

                            render :new, status: :unprocessable_entity
                        end
                        format.json { render json: @contract.errors, status: :unprocessable_entity }
                        # :nocov:
                    elsif @contract.save
                        @decision = @contract.decisions.build(decision: ContractStatus::CREATED, user: current_user)
                        @decision.save
                        @decision = @contract.decisions.build(decision: ContractStatus::IN_PROGRESS, user: current_user)
                        @decision.save
                        if contract_documents_upload.present?
                            # :nocov:
                            handle_contract_documents(contract_documents_upload,
                                                      contract_documents_attributes, 'approved')
                            # :nocov:
                        end
                        format.html do
                            # erase the session value after successful creation of contract
                            # so that the value of the dropdowns will not be retained for the next contract creation
                            session[:value_type] = nil
                            session[:vendor_visible_id] = nil
                            session[:funding_source] = nil
                            redirect_to contract_url(@contract), notice: 'Contract was successfully created.'
                        end
                        format.json { render :show, status: :created, location: @contract }
                    else
                        # :nocov:
                        format.html do
                            # to retain the value of the vendor dropdown and value type dropdown after validation error
                            retain_dropdown_values(value_type_selected, vendor_selection, funding_source_selected)

                            render :new, status: :unprocessable_entity
                        end
                        # format.html { render :new, status: :unprocessable_entity, session[:value_type] = params[:contract][:value_type]}
                        format.json { render json: @contract.errors, status: :unprocessable_entity }
                        # :nocov:
                    end
                end
            rescue StandardError => e
                # :nocov:
                # If error type is Oso::ForbiddenError, then the user is not authorized
                if e.instance_of?(Oso::ForbiddenError)
                    @contract.errors.add(:base, 'You are not authorized to create a contract')
                    message = 'You are not authorized to create a contract'
                else
                    # status = :unprocessable_entity
                    message = e.message
                end
                format.html { redirect_to contracts_path, alert: message }
                # :nocov:
            end
        end
    end

    # PATCH/PUT /contracts/1 or /contracts/1.json
    def update
        # :nocov:
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb @contract.title, contract_path(@contract)
        add_breadcrumb 'Edit', edit_contract_path(@contract)

        # Determine if amendment or contract edit
        source_page = determine_source_page

        add_breadcrumb source_page.capitalize, send("#{source_page}_contract_path", @contract)

        handle_if_new_vendor
        handle_if_new_funding_source

        # Remove the new vendor from the params
        params[:contract].delete(:new_vendor_name)
        params[:contract].delete(:new_funding_source)
        contract_documents_upload = params[:contract][:contract_documents]
        contract_documents_attributes = params[:contract][:contract_documents_attributes]

        vendor_selection = params[:vendor_visible_id]
        value_type_selected = params[:contract][:value_type]
        funding_source_selected = params[:contract][:funding_source]
        params[:contract][:new_funding_source]

        # Delete the contract_documents from the params
        # so that it doesn't get saved as a contract attribute
        params[:contract].delete(:contract_documents)
        params[:contract].delete(:contract_documents_attributes)
        params[:contract].delete(:contract_document_type_hidden)
        params[:contract].delete(:vendor_visible_id)
        contract_params_clean = contract_params
        contract_params_clean.delete(:new_funding_source)


        # :nocov:
        # Only for 'contract' current_type
        unless @contract.current_type == 'contract'
            # Find changes and save them
            changes_made = track_contract_changes(@contract, contract_params, contract_documents_upload, contract_documents_attributes)
            if changes_made == nil
                return
            end
            latest_log = @contract.modification_logs.order(updated_at: :desc).first

            if latest_log&.status == 'rejected' || latest_log&.status != 'pending'
                ModificationLog.create!(
                    contract_id: @contract.id,
                    modified_by_id: current_user.id,
                    modification_type: @contract.current_type,
                    changes_made:,
                    status: 'pending',
                    modified_at: Time.current
                )
            elsif latest_log&.status == 'pending'
                combined_changes = latest_log.changes_made.merge(changes_made) { |_key, old, new| [old[0], new[1]] }
                latest_log.update!(
                    changes_made: combined_changes,
                    modified_at: Time.current
                )
            end
            success_message = 'Contract was successfully updated.'
            redirect_to contract_url(@contract), notice: success_message
            return
        end
        # :nocov:

        respond_to do |format|
            ActiveRecord::Base.transaction do
                OSO.authorize(current_user, source_page, @contract)
                if @contract[:point_of_contact_id].blank? && contract_params[:point_of_contact_id].blank?
                    # :nocov:
                    @contract.errors.add(:base, 'Point of contact is required')
                    format.html do
                        retain_dropdown_values(value_type_selected, vendor_selection, funding_source_selected)

                        render source_page, status: :unprocessable_entity
                    end
                    format.json { render json: @contract.errors, status: :unprocessable_entity }
                    # :nocov:
                elsif contract_params[:point_of_contact_id].present? && !User.find(contract_params[:point_of_contact_id]).is_active
                    # :nocov:
                    if User.find(contract_params[:point_of_contact_id]).redirect_user_id.present?
                        @contract.errors.add(:base,
                                             "#{User.find(contract_params[:point_of_contact_id]).full_name} is not active, use #{User.find(User.find(contract_params[:point_of_contact_id]).redirect_user_id).full_name} instead")
                    else
                        @contract.errors.add(:base,
                                             "#{User.find(contract_params[:point_of_contact_id]).full_name} is not active")
                    end
                    format.html do
                        # to retain the value of the vendor dropdown and value type dropdown after validation error
                        retain_dropdown_values(value_type_selected, vendor_selection, funding_source_selected)

                        render source_page, status: :unprocessable_entity
                    end
                    format.json { render json: @contract.errors, status: :unprocessable_entity }
                # :nocov:
                # Excuse this monster if statement, it's just checking if the user is associated with the entity, and for
                # some reason nested-if statements don't work here when you use format (ie. UnkownFormat error)
                elsif contract_params[:point_of_contact_id].present? && User.find(contract_params[:point_of_contact_id]).level == UserLevel::THREE && !User.find(contract_params[:point_of_contact_id]).entities.include?(Entity.find((contract_params[:entity_id].presence || @contract.entity_id)))
                    # :nocov:
                    @contract.errors.add(:base,
                                         "#{User.find((contract_params[:point_of_contact_id].presence || @contract.point_of_contact_id)).full_name} is not associated with #{Entity.find((contract_params[:entity_id].presence || @contract.entity_id)).name}")
                    format.html do
                        # to retain the value of the vendor dropdown and value type dropdown after validation error
                        retain_dropdown_values(value_type_selected, vendor_selection, funding_source_selected)

                        render source_page, status: :unprocessable_entity
                    end
                    format.json { render json: @contract.errors, status: :unprocessable_entity }
                    # :nocov:
                elsif %w[renew amend].include?(source_page)
                    # :nocov:
                    @contract = Contract.find(params[:id])
                    # TODO: handle the exception fields of renew/amend

                    changes_made = track_contract_changes(@contract, contract_params, contract_documents_upload, contract_documents_attributes)
                    changes_made.to_json

                    log_attributes = {
                        contract_id: @contract.id,
                        modified_by_id: current_user.id,
                        modification_type: source_page,
                        changes_made:,
                        status: 'pending',
                        modified_at: Time.current
                    }

                    if ModificationLog.create(log_attributes)

                        @contract.update(contract_status: ContractStatus::IN_PROGRESS)
                        @contract.update(current_type: source_page)
                        format.html do
                            # erase the session value after successful creation of contract
                            # so that the value of the dropdowns will not be retained for the next contract creation
                            session[:value_type] = nil
                            session[:vendor_visible_id] = nil
                            success_message = case source_page
                                              when 'renew'
                                                  "Renewal request for #{@contract.title} submitted successfully and is pending approval."
                                              when 'amend'
                                                  "Amendment request for #{@contract.title} submitted successfully and is pending approval"
                                              else
                                                  'Contract was successfully updated.'
                                              end
                            # redirect_to send('modify_contracts_path', @contract), notice: success_message
                            redirect_to(
                                %w[renew amend].include?(source_page) ? contract_url(@contract) : modify_contracts_path,
                                notice: success_message
                            )
                        end
                    else
                        render source_page, alert: 'Failed to update TempContract.'
                    end
                    # :nocov:
                elsif @contract.update(contract_params)
                    if contract_documents_upload.present?
                        # :nocov:
                        handle_contract_documents(contract_documents_upload,
                                                  contract_documents_attributes, 'approved')

                        # Log document additions in changes_made
                        added_documents = contract_documents_upload.reject(&:blank?).map(&:original_filename)
                        changes_made['Document Added'] = [nil, added_documents] unless added_documents.empty?
                        # :nocov:
                    end
                    format.html do
                        # erase the session value after successful creation of contract
                        # so that the value of the dropdowns will not be retained for the next contract creation
                        session[:value_type] = nil
                        session[:vendor_visible_id] = nil
                        redirect_to edit_contract_path(@contract), notice: 'Contract was successfully updated.'
                        format.json { render :show, status: :ok, location: @contract }
                    end
                else
                    format.html do
                        # to retain the value of the vendor dropdown and value type dropdown after validation error
                        retain_dropdown_values(value_type_selected, vendor_selection, funding_source_selected)
                        render source_page, status: :unprocessable_entity
                    end
                    format.json { render json: @contract.errors, status: :unprocessable_entity }
                end
            end
        rescue StandardError => e
            # :nocov:
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
            # :nocov:
        end
    end

    # Parameter and Callback Helpers
    # Only allow a list of trusted parameters through.
    def contract_params
        allowed = %i[
            title description starts_at ends_at contract_status entity_id
            program_id point_of_contact_id vendor_id total_amount contract_type
            number new_vendor_name contract_documents contract_document_type_hidden
            contract_documents_attributes contract_status value_type vendor_visible_id
            contract_value current_type funding_source new_funding_source
        ]
        params.require(:contract).permit(allowed)
    end

    def determine_source_page
        referer = request.referer
        return 'renew' if referer&.include?('renew')
        return 'amend' if referer&.include?('amend')
        'edit'
    end

    def track_contract_changes(contract, contract_params, contract_documents_upload, contract_documents_attributes)
        changes_made = {}

        # Iterate over each parameter and compare old vs. new values
        contract_params.each do |key, new_value|
            old_value = contract.send(key)

            # Type conversion based on the type of the old value
            new_value = case old_value
                        when Integer
                            new_value.to_i
                        when Float
                            new_value.to_f
                        when BigDecimal
                            BigDecimal(new_value)
                        when Date
                            new_value.to_date
                        else
                            new_value
                        end

            # Skip if values haven't changed
            next unless old_value != new_value

            # if key == 'ends_at'
            #     if !old_value.is_a?(Time) && !new_value.is_a?(Time)
            #         next
            #     end
            # end

            # Format `Time` values for comparison and display
            old_value = old_value.strftime('%Y-%m-%d') if old_value.is_a?(Time)
            new_value = new_value.strftime('%Y-%m-%d') if new_value.is_a?(Time)

            changes_made[key] = [old_value, new_value]
        end

        # Handle document uploads and add them to the changes
        if contract_documents_upload.present?
            documents_added = handle_contract_documents(contract_documents_upload, contract_documents_attributes, 'pending')
            changes_made['Document Added'] = [nil, documents_added] if documents_added.any?
        end

        # Check if any changes were made
        if changes_made.empty?
            flash[:alert] = 'No value is edited!'
            redirect_to edit_contract_path(contract) and return nil
        end

        changes_made
    end

    def retain_dropdown_values(value_type_selected, vendor_selection, funding_source_selected)
        session[:value_type] = value_type_selected
        session[:vendor_visible_id] = vendor_selection
        session[:funding_source] = funding_source_selected
        @vendor_visible_id = session[:vendor_visible_id] || ''
        @value_type = session[:value_type] || ''
        @funding_source_selected = session[:funding_source] || ''
    end

    # :nocov:
    def contract_files
        contract_document = ContractDocument.find(params[:id])
        send_file contract_document.file.path, type: contract_document.file_content_type, disposition: :inline
    end
    # :nocov:

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
                # :nocov:
            rescue ActiveRecord::StatementInvalid
                # Otherwise, sort by title
                Contract.order(title: :asc)
                # :nocov:
            end
        end

        # Returns the sorted contracts
    end

    def search_contracts(contracts)
        # :nocov:
        # Search by the query string parameter "search"
        # Search in "title", "description", and "key_words"
        contracts.where('title LIKE ? OR description LIKE ? OR key_words LIKE ?', "%#{params[:search]}%",
                        "%#{params[:search]}%", "%#{params[:search]}%")
        # :nocov:
    end

    # Helpers
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

    def handle_if_new_funding_source
        # Check if the funding source is new
        if params[:contract][:funding_source] == 'new'
            if params[:contract][:new_funding_source].present?
                @contract.funding_source = params[:contract][:new_funding_source]
            else
                @contract.errors.add(:funding_source, 'New funding source cannot be empty')
            end
        else
            # If not a new funding source, set the selected value
            @contract.funding_source = params[:contract][:funding_source]
        end
        params[:contract].delete(:new_funding_source)
    end

    # TODO: This is a temporary solution
    # File upload is a seperate issue that will be handled with a dropzone
    def handle_contract_documents(contract_documents_upload, contract_documents_attributes, initial_status)
        documents_added = [] # Collect added document names

        contract_documents_upload.each do |doc|
            next if doc.blank?

            # Create a file name for the official file
            official_file_name = contract_document_filename(@contract, File.extname(doc.original_filename))

            # Avoid duplicates
            next if @contract.contract_documents.find_by(orig_file_name: doc.original_filename)

            # Save the file to the filesystem
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
                document_type:,
                status: initial_status # Set status based on contract type
            )

            # Add the contract_document to the contract
            @contract.contract_documents << contract_document
            documents_added << doc.original_filename
        end
        documents_added
    end
    # :nocov:

    # Logging
    def reject
        @contract = Contract.find(params[:id])
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb @contract.title, contract_path(@contract)
        add_breadcrumb 'Reject', reject_contract_path(@contract)
    end

    def log_rejection
        # :nocov:
        @contract = Contract.find(params[:contract_id])
        ActiveRecord::Base.transaction do
            @reason = params[:contract][:rejection_reason]
            if @contract.current_type == 'renew' || @contract.current_type == 'amend'

                message_text = @contract.current_type == 'renew' ? 'Renewal' : 'Amendment'

                # update contract status and current type
                @contract.update(contract_status: ContractStatus::IN_PROGRESS)
                latest_log = @contract.modification_logs.where(status: 'pending').order(updated_at: :desc).first

                # Remove documents added during this amendment/renewal
                if latest_log&.changes_made&.dig('Document Added').present?
                    latest_log.changes_made['Document Added'].each do |filename|
                        doc = @contract.contract_documents.find_by(orig_file_name: filename)
                        doc&.destroy
                    end
                    Rails.logger.info "Removed documents associated with rejected changes: #{latest_log.changes_made['Document Added']}"
                end

                # update latest modification log's status
                latest_log.update(status: 'rejected', remarks: @reason, approved_by: current_user.full_name, modified_at: Time.current)
                latest_log.reject_amend_notification
                @decision = @contract.decisions.build(reason: "#{message_text} request rejected: #{@reason}", decision: ContractStatus::REJECTED, user: current_user)
                @decision.save
                if @decision.save
                    @contract.modification_logs.where(status: 'pending').update_all(status: 'rejected')
                    redirect_to contract_url(@contract), notice: "#{message_text} request was rejected."
                else
                    redirect_to contract_url(@contract), alert: "#{message_text} rejection failed"
                end
            else
                @contract.update(contract_status: ContractStatus::IN_PROGRESS)
                @decision = @contract.decisions.build(reason: @reason, decision: ContractStatus::REJECTED, user: current_user)
                @decision_in_prog = @contract.decisions.build(reason: nil, decision: ContractStatus::IN_PROGRESS, user: current_user)
                if @decision.save && @decision_in_prog.save
                    @contract.modification_logs.where(status: 'pending').update_all(status: 'rejected')
                    redirect_to contract_url(@contract), notice: 'Contract was Rejected.'
                else
                    redirect_to contract_url(@contract), alert: 'Contract Rejection failed.'
                end
            end
        end
        # :nocov:
    end

    def void
        @contract = Contract.find(params[:id])
    end

    def log_hard_rejection
        # :nocov:
        ActiveRecord::Base.transaction do
            @contract = Contract.find(params[:contract_id] || params[:id]) 
            @void_reason = params[:contract][:void_reason]
        
            message_text = @contract.current_type == 'renew' ? 'Renewal' : 'Amendment'
            @contract.update(contract_status: ContractStatus::APPROVED, current_type: 'contract')
            latest_log = @contract.modification_logs.where(status: 'pending').order(updated_at: :desc).first
        
            if latest_log.changes_made['Document Added'].present?
            latest_log.changes_made['Document Added'].each do |filename|
                doc = @contract.contract_documents.find_by(orig_file_name: filename)
                doc&.destroy
            end
            Rails.logger.info "Removed documents associated with hard-rejected changes: #{latest_log.changes_made['Document Added']}"
            end
        
            latest_log.update(status: 'approved', remarks: @void_reason, approved_by: current_user.full_name, modified_at: Time.current)
            latest_log.void_amend_notification
        
            @decision = @contract.decisions.build(
                reason: @void_reason,
                decision: ContractStatus::APPROVED,
                user: current_user
            )
        
            if @decision.save
                @contract.modification_logs.where(status: 'pending').update_all(status: 'approved')
                redirect_to contract_url(@contract), notice: "#{message_text} request was hard rejected."
            else
                redirect_to contract_url(@contract), alert: "#{message_text} hard rejection failed."
            end
        end
        # :nocov:
    end
      
    def log_approval
        # :nocov:
        ActiveRecord::Base.transaction do
            @contract = Contract.find(params[:contract_id])
            if @contract.current_type == 'renew' || @contract.current_type == 'amend'

                message_text = @contract.current_type == 'renew' ? 'Renewal' : 'Amendment'

                latest_log = @contract.modification_logs.where(status: 'pending').order(updated_at: :desc).first
                Rails.logger.debug latest_log

                # Apply latest modification log
                if latest_log != nil
                    latest_log.changes_made.each do |key, value|
                        if key == 'Document Added'
                            # Update status of approved documents
                            value[1].each do |filename|
                                doc = @contract.contract_documents.find_by(orig_file_name: filename)
                                doc&.update(status: 'approved') # Mark as approved
                            end
                            Rails.logger.info "Documents approved: #{value[1]}"
                        else
                            @contract.update!(key => value[1])
                        end
                    end
                end

                @contract.contract_documents.update_all(status: 'approved')
                # Update contract status and current type
                @contract.update(contract_status: ContractStatus::APPROVED, current_type: 'contract')

                # Update latest modification log's status
                if latest_log != nil
                    latest_log.update(status: 'approved', approved_by: current_user.full_name, modified_at: Time.current)
                end

                if latest_log == nil
                    @decision = @contract.decisions.build(reason: "No amendment found. Approved.", decision: ContractStatus::APPROVED, user: current_user)
                elsif
                    @decision = @contract.decisions.build(reason: "#{message_text} request was Approved", decision: ContractStatus::APPROVED, user: current_user)
                end
                @decision.save
                if @decision.save
                    @contract.modification_logs.where(status: 'pending').update_all(status: 'approved')
                    redirect_to contract_url(@contract), notice: "#{message_text} request was Approved"
                else
                    redirect_to contract_url(@contract), alert: "#{message_text} approval failed"
                end
            else
                @contract.contract_documents.update_all(status: 'approved')
                @contract.update(contract_status: ContractStatus::APPROVED)
                @decision = @contract.decisions.build(reason: nil, decision: ContractStatus::APPROVED, user: current_user)
                @decision.save
                if @decision.save
                    @contract.modification_logs.where(status: 'pending').update_all(status: 'approved')
                    redirect_to contract_url(@contract), notice: 'Contract was Approved.'
                else
                    redirect_to contract_url(@contract), alert: 'Contract Approval failed.'
                end
            end
        end
        # :nocov:
    end

    def log_return
        # :nocov:
        ActiveRecord::Base.transaction do
            @contract = Contract.find(params[:contract_id])
            @contract.update(contract_status: ContractStatus::IN_PROGRESS)
            @decision = @contract.decisions.build(reason: nil, decision: ContractStatus::IN_PROGRESS,
                                                  user: current_user)
            @decision.save
            redirect_to contract_url(@contract), notice: 'Contract was returned to In Progress.'
        end
        # :nocov:
    end

    def log_submission
        # :nocov:
        ActiveRecord::Base.transaction do
            @contract = Contract.find(params[:contract_id])
            @contract.update(contract_status: ContractStatus::IN_REVIEW)
            @decision = @contract.decisions.build(reason: nil, decision: ContractStatus::IN_REVIEW, user: current_user)
            @decision.save
            redirect_to contract_url(@contract), notice: 'Contract was Submitted.'
        end
        # :nocov:
    end

    # Deprecated
    # :nocov:
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
    # :nocov:
end


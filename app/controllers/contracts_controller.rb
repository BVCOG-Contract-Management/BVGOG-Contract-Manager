class ContractsController < ApplicationController
    before_action :set_contract, only: %i[show edit update]

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

        @decisions = @contract.decisions.order(created_at: :asc)
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
        @value_type=  ''
        @contract = Contract.new
    end

    # GET /contracts/1/edit
    def edit
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
        add_breadcrumb 'Edit', edit_contract_path(@contract)
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
        # Delete the contract_documents from the params
        # so that it doesn't get saved as a contract attribute
        params[:contract].delete(:contract_documents)
        params[:contract].delete(:contract_documents_attributes)
        params[:contract].delete(:contract_document_type_hidden)
        params[:contract].delete(:vendor_visible_id)

        params[:contract][:total_amount] = handle_total_amount_value(params[:contract], value_type_selected)
        
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
                        # :nocov:
                        @contract.errors.add(:base, 'Point of contact is required')
                        format.html {
                            #to retain the value of the vendor dropdown and value type dropdown after validation error
                            session[:value_type] = value_type_selected
                            session[:vendor_visible_id] = vendor_selection
                            @vendor_visible_id = session[:vendor_visible_id] || ''
                            @value_type = session[:value_type] || ''
                            render :new, status: :unprocessable_entity 
                        }
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
                        format.html {
                            #to retain the value of the vendor dropdown and value type dropdown after validation error
                            session[:value_type] = value_type_selected
                            session[:vendor_visible_id] = vendor_selection
                            @vendor_visible_id = session[:vendor_visible_id] || ''
                            @value_type = session[:value_type] || ''
                            render :new, status: :unprocessable_entity 
                        }
                        # format.html { render :new, status: :unprocessable_entity, session[:value_type] = params[:contract][:value_type] }
                        
                        format.json { render json: @contract.errors, status: :unprocessable_entity }
                        # :nocov:
                    elsif User.find(@contract.point_of_contact_id).level == UserLevel::THREE && !User.find(@contract.point_of_contact_id).entities.include?(@contract.entity)
                        # :nocov:
                        @contract.errors.add(:base,
                                             "#{User.find(@contract.point_of_contact_id).full_name} is not associated with #{@contract.entity.name}")
                        # format.html { render :new, status: :unprocessable_entity,, session[:value_type] = params[:contract][:value_type] }
                        format.html {
                            #to retain the value of the vendor dropdown and value type dropdown after validation error
                            session[:value_type] = value_type_selected
                            session[:vendor_visible_id] = vendor_selection
                            @vendor_visible_id = session[:vendor_visible_id] || ''
                            @value_type = session[:value_type] || ''
                            render :new, status: :unprocessable_entity 
                        }
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
                                                      contract_documents_attributes)
                            # :nocov:
                        end
                        format.html do
                            #erase the session value after successful creation of contract
                            #so that the value of the dropdowns will not be retained for the next contract creation
                            session[:value_type] = nil
                            session[:vendor_visible_id] = nil
                            redirect_to contract_url(@contract), notice: 'Contract was successfully created.'
                        end
                        format.json { render :show, status: :created, location: @contract }
                    else
                        # :nocov:
                        format.html {
                            #to retain the value of the vendor dropdown and value type dropdown after validation error
                            session[:value_type] = value_type_selected
                            session[:vendor_visible_id] = vendor_selection
                            @vendor_visible_id = session[:vendor_visible_id] || ''
                            @value_type = session[:value_type] || ''
                            render :new, status: :unprocessable_entity 
                        }
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
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb @contract.title, contract_path(@contract)
        add_breadcrumb 'Edit', edit_contract_path(@contract)

        handle_if_new_vendor
        # Remove the new vendor from the params
        params[:contract].delete(:new_vendor_name)
        contract_documents_upload = params[:contract][:contract_documents]
        contract_documents_attributes = params[:contract][:contract_documents_attributes]

        vendor_selection = params[:vendor_visible_id]
        value_type_selected = params[:contract][:value_type]

        # Delete the contract_documents from the params
        # so that it doesn't get saved as a contract attribute
        params[:contract].delete(:contract_documents)
        params[:contract].delete(:contract_documents_attributes)
        params[:contract].delete(:contract_document_type_hidden)
        params[:contract].delete(:vendor_visible_id)

        params[:contract][:total_amount] = handle_total_amount_value(params[:contract], value_type_selected)

        respond_to do |format|
            ActiveRecord::Base.transaction do
                OSO.authorize(current_user, 'edit', @contract)
                if @contract[:point_of_contact_id].blank? && contract_params[:point_of_contact_id].blank?
                    # :nocov:
                    @contract.errors.add(:base, 'Point of contact is required')
                    format.html { 
                        session[:value_type] = value_type_selected
                        session[:vendor_visible_id] = vendor_selection
                        @vendor_visible_id = session[:vendor_visible_id] || ''
                        @value_type = session[:value_type] || ''
                        render :edit, status: :unprocessable_entity 
                    }
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
                    format.html { 
                        #to retain the value of the vendor dropdown and value type dropdown after validation error
                        session[:value_type] = value_type_selected
                        session[:vendor_visible_id] = vendor_selection
                        @vendor_visible_id = session[:vendor_visible_id] || ''
                        @value_type = session[:value_type] || ''
                        render :edit, status: :unprocessable_entity 
                    }
                    format.json { render json: @contract.errors, status: :unprocessable_entity }
                    # :nocov:
                # Excuse this monster if statement, it's just checking if the user is associated with the entity, and for
                # some reason nested-if statements don't work here when you use format (ie. UnkownFormat error)
                elsif contract_params[:point_of_contact_id].present? && User.find(contract_params[:point_of_contact_id]).level == UserLevel::THREE && !User.find(contract_params[:point_of_contact_id]).entities.include?(Entity.find((contract_params[:entity_id].presence || @contract.entity_id)))
                    # :nocov:
                    @contract.errors.add(:base,
                                         "#{User.find((contract_params[:point_of_contact_id].presence || @contract.point_of_contact_id)).full_name} is not associated with #{Entity.find((contract_params[:entity_id].presence || @contract.entity_id)).name}")
                    format.html { 
                        #to retain the value of the vendor dropdown and value type dropdown after validation error
                        session[:value_type] = value_type_selected
                        session[:vendor_visible_id] = vendor_selection
                        @vendor_visible_id = session[:vendor_visible_id] || ''
                        @value_type = session[:value_type] || ''
                        render :edit, status: :unprocessable_entity 
                    }
                    format.json { render json: @contract.errors, status: :unprocessable_entity }
                    # :nocov:
                elsif @contract.update(contract_params)
                    if contract_documents_upload.present?
                        # :nocov:
                        handle_contract_documents(contract_documents_upload,
                                                  contract_documents_attributes)
                        # :nocov:
                    end
                    format.html do
                        #erase the session value after successful creation of contract
                        #so that the value of the dropdowns will not be retained for the next contract creation
                        session[:value_type] = nil
                        session[:vendor_visible_id] = nil
                        redirect_to contract_url(@contract), notice: 'Contract was successfully updated.'
                    end
                    format.json { render :show, status: :ok, location: @contract }
                else
                    format.html { 
                        #to retain the value of the vendor dropdown and value type dropdown after validation error
                        session[:value_type] = value_type_selected
                        session[:vendor_visible_id] = vendor_selection
                        @vendor_visible_id = session[:vendor_visible_id] || ''
                        @value_type = session[:value_type] || ''
                        render :edit, status: :unprocessable_entity 
                    }
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

    def handle_total_amount_value(contract_params, value_type)
        if value_type == "Not Applicable"
          contract_params[:total_amount] = 0
          contract_params[:value_type] = "Not Applicable"
        elsif value_type == "Calculated Value"
            contract_params[:total_amount]= get_calculated_value(contract_params) 
            contract_params[:value_type] = "Calculated Value"
        end
      
        contract_params[:total_amount]
    end
      
    def get_calculated_value(contract_params)
        amount_dollar = contract_params[:amount_dollar].to_i       # the value of the contract for the amount_duration (days, weeks, months, years)
        initial_term = contract_params[:initial_term_amount].to_i  # no. of days, weeks, months, years the contract is for
        amount_duration_value = contract_params[:amount_duration]  # the amount of the contract for {days, weeks, months, years}
        initial_term_duration_value = contract_params[:initial_term_duration] # the number of {days, weeks, months, years} the contract is for
        
        case amount_duration_value
        when 'day'
            case initial_term_duration_value
            when 'week'
                contract_params[:total_amount] = amount_dollar * initial_term * 7
            when 'month'
                contract_params[:total_amount] = amount_dollar * initial_term * 30
            when 'year'
                contract_params[:total_amount] = amount_dollar * initial_term * 365
            end
        when 'week'
            case initial_term_duration_value
            when 'day'
                contract_params[:total_amount] = amount_dollar * initial_term / 7
            when 'month'
                contract_params[:total_amount] = amount_dollar * initial_term * 4
            when 'year'
                contract_params[:total_amount] = amount_dollar * initial_term * 52
            end
        when 'month'
            case initial_term_duration_value
            when 'day'
                contract_params[:total_amount] = amount_dollar * initial_term / 30
            when 'week'
                contract_params[:total_amount] = amount_dollar * initial_term / 4
            when 'year'
                contract_params[:total_amount] = amount_dollar * initial_term * 12
            end
        when 'year'
            case initial_term_duration_value
            when 'day'
                contract_params[:total_amount] = amount_dollar * initial_term / 365
            when 'week'
                contract_params[:total_amount] = amount_dollar * initial_term / 52
            when 'month'
                contract_params[:total_amount] = amount_dollar * initial_term / 12
            end
        end
        return contract_params[:total_amount]
    end

    def get_file
    end
    # :nocov:
    def contract_files
        contract_document = ContractDocument.find(params[:id])
        send_file contract_document.file.path, type: contract_document.file_content_type, disposition: :inline
    end
    # :nocov:

    def reject
        @contract = Contract.find(params[:id])
        add_breadcrumb 'Contracts', contracts_path
        add_breadcrumb @contract.title, contract_path(@contract)
        add_breadcrumb 'Reject', reject_contract_path(@contract)
    end

    def log_rejection
        @contract = Contract.find(params[:contract_id])
        ActiveRecord::Base.transaction do
            @reason = params[:contract][:rejection_reason]

            @contract.update(contract_status: ContractStatus::IN_PROGRESS)
            @decision = @contract.decisions.build(reason: @reason, decision: ContractStatus::REJECTED, user: current_user)
            @decision_in_prog = @contract.decisions.build(reason: nil, decision: ContractStatus::IN_PROGRESS, user: current_user)
            if @decision.save && @decision_in_prog.save
                redirect_to contract_url(@contract), notice: 'Contract was Rejected.'
            else
                # :nocov:
                redirect_to contract_url(@contract), alert: 'Contract Rejection failed.'
                # :nocov:
            end
        end
    end

    def log_approval
        ActiveRecord::Base.transaction do
            @contract = Contract.find(params[:contract_id])
            @contract.update(contract_status: ContractStatus::APPROVED)
            @decision = @contract.decisions.build(reason: nil, decision: ContractStatus::APPROVED, user: current_user)
            @decision.save
            redirect_to contract_url(@contract), notice: 'Contract was Approved.'
        end
    end

    def log_return
        ActiveRecord::Base.transaction do
            @contract = Contract.find(params[:contract_id])
            @contract.update(contract_status: ContractStatus::IN_PROGRESS)
            @decision = @contract.decisions.build(reason: nil, decision: ContractStatus::IN_PROGRESS,
                                                  user: current_user)
            @decision.save
            redirect_to contract_url(@contract), notice: 'Contract was returned to In Progress.'
        end
    end

    def log_submission
        ActiveRecord::Base.transaction do
            @contract = Contract.find(params[:contract_id])
            @contract.update(contract_status: ContractStatus::IN_REVIEW)
            @decision = @contract.decisions.build(reason: nil, decision: ContractStatus::IN_REVIEW, user: current_user)
            @decision.save
            redirect_to contract_url(@contract), notice: 'Contract was Submitted.'
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
			total_amount
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
            extension_count
            max_extension_count
            extension_duration
            extension_duration_units
            value_type
            vendor_visible_id
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
        # :nocov:
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
        # :nocov:
    end
end

class ContractsController < ApplicationController
  before_action :set_contract, only: %i[ show edit update destroy ]

  # GET /contracts or /contracts.json
  def index
    add_breadcrumb "Contracts", contracts_path
    flash.now.notice = "Welcome to the Contracts Management System!"
    # Sort contracts
    @contracts = sort_contracts().page params[:page]
    # Search contracts
    @contracts = search_contracts(@contracts) if params[:search].present?
  end

  # GET /contracts/1 or /contracts/1.json
  def show
    add_breadcrumb "Contracts", contracts_path
    add_breadcrumb @contract.title, contract_path(@contract)
  end

  # GET /contracts/new
  def new
    add_breadcrumb "Contracts", contracts_path
    add_breadcrumb "New Contract", new_contract_path
    @contract = Contract.new
  end

  # GET /contracts/1/edit
  def edit
    add_breadcrumb "Contracts", contracts_path
    add_breadcrumb @contract.title, contract_path(@contract)
    add_breadcrumb "Edit", edit_contract_path(@contract)
  end

  # POST /contracts or /contracts.json
  def create

    contract_documents_upload = params[:contract][:contract_documents]
    # Delete the contract_documents from the params
    # so that it doesn't get saved as a contract attribute
    params[:contract].delete(:contract_documents)

    @contract = Contract.new(contract_params.merge(contract_status: ContractStatus::IN_PROGRESS))

    handle_if_new_vendor

    respond_to do |format|
      ActiveRecord::Base.transaction do
        if @contract.save
          puts "Contract saved successfully"
          if contract_documents_upload.present?
            handle_contract_documents(contract_documents_upload)
          end
          format.html { redirect_to contract_url(@contract), notice: "Contract was successfully created." }
          format.json { render :show, status: :created, location: @contract }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @contract.errors, status: :unprocessable_entity }
        end
      end
    rescue => e
      puts "Error: #{e}"
      @contract.destroy if @contract.persisted?
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @contract.errors, status: :unprocessable_entity }
    end

  end

  # PATCH/PUT /contracts/1 or /contracts/1.json
  def update

    handle_if_new_vendor
    contract_documents_upload = params[:contract][:contract_documents]
    # Delete the contract_documents from the params
    # so that it doesn't get saved as a contract attribute
    params[:contract].delete(:contract_documents)
    
    respond_to do |format|
      ActiveRecord::Base.transaction do
        if @contract.update(contract_params)
          if contract_documents_upload.present?
            handle_contract_documents(contract_documents_upload)
          end
          puts "Contract updated successfully"
          format.html { redirect_to contract_url(@contract), notice: "Contract was successfully updated." }
          format.json { render :show, status: :ok, location: @contract }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @contract.errors, status: :unprocessable_entity }
        end
      end
    end
    rescue => e
      puts "Error: #{e}"
      # Rollback the transaction
      contract.reload
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @contract.errors, status: :unprocessable_entity }
  end

  # DELETE /contracts/1 or /contracts/1.json
  def destroy
    @contract.destroy

    respond_to do |format|
      format.html { redirect_to contracts_url, notice: "Contract was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def get_file
    contract_document = ContractDocument.find(params[:id])
    send_file contract_document.file.path, type: contract_document.file_content_type, disposition: :inline
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contract
    @contract = Contract.find(params[:id])
  end

  def set_users
    @users = User.all
  end

  # Only allow a list of trusted parameters through.
  def contract_params
    allowed = [
      :title, 
      :description, 
      :key_words, 
      :starts_at, 
      :ends_at, 
      :contract_status, 
      :entity_id, 
      :program_id, 
      :point_of_contact_id, 
      :vendor_id,
      :amount_dollar,
      :amount_duration,
      :initial_term_amount,
      :initial_term_duration,
      :end_trigger,
      :contract_type,
      :requires_rebid,
      :number,
      :contract_documents,
    ]
    params.require(:contract).permit(allowed)
  end

  def sort_contracts
    # Sorts by the query string parameter "sort"
    # Since some columns are combinations or associations, we need to handle them separately
    asc = params[:order] ? params[:order] : "asc"
    contracts = case params[:sort]
      when "point_of_contact"
        # Sort by the name of the point of contact
        Contract.joins(:point_of_contact).order("users.last_name #{asc}").order("users.first_name #{asc}")
      when "vendor"
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
    contracts
  end

  def search_contracts(contracts)
    # Search by the query string parameter "search"
    # Search in "title", "description", and "key_words"
    contracts.where("title LIKE ? OR description LIKE ? OR key_words LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
  end

  def handle_if_new_vendor
    # Check if the vendor is new
    if params[:contract][:vendor_id] == "new"
      # Create a new vendor
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
  def handle_contract_documents(contract_documents_upload)
    for doc in contract_documents_upload
      if doc.present?
        # Create a file name for the official file
        official_file_name = contract_document_filename(@contract, File.extname(doc.original_filename))
        # Write the file to the if the contract does not have 
        # a contract_document with the same orig_file_name
        if !@contract.contract_documents.find_by(orig_file_name: doc.original_filename)
          # Write the file to the filesystem
          File.open(Rails.root.join(@bvcog_config.contracts_path, official_file_name), 'wb') do |file|
            file.write(doc.read)
          end
          # Create a new contract_document
          contract_document = ContractDocument.new(
            orig_file_name: doc.original_filename, 
            file_name: official_file_name,
            full_path: Rails.root.join(@bvcog_config.contracts_path, official_file_name).to_s,
          )
          # Add the contract_document to the contract
          @contract.contract_documents << contract_document
        end
      end
    end
  end
end
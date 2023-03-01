class ContractsController < ApplicationController
  before_action :set_contract, only: %i[ show edit update destroy ]

  # GET /contracts or /contracts.json
  def index
    add_breadcrumb "Contracts", contracts_path

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
    @contract = Contract.new(contract_params.merge(contract_status: ContractStatus::IN_PROGRESS))

    handle_if_new_vendor
    handle_contract_documents

    respond_to do |format|
      puts contract_params
      if @contract.save
        format.html { redirect_to contract_url(@contract), notice: "Contract was successfully created." }
        format.json { render :show, status: :created, location: @contract }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contracts/1 or /contracts/1.json
  def update

    handle_if_new_vendor
    handle_contract_documents

    respond_to do |format|
      if @contract.update(contract_params)
        puts "Contract updated successfully"
        format.html { redirect_to contract_url(@contract), notice: "Contract was successfully updated." }
        format.json { render :show, status: :ok, location: @contract }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contracts/1 or /contracts/1.json
  def destroy
    @contract.destroy

    respond_to do |format|
      format.html { redirect_to contracts_url, notice: "Contract was successfully destroyed." }
      format.json { head :no_content }
    end
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
def handle_contract_documents
  params[:contract].delete(:contract_documents)
end
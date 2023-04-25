class VendorsController < ApplicationController
  before_action :set_vendor, only: %i[ show edit review update destroy ]

  # GET /vendors or /vendors.json
  def index
    add_breadcrumb "Vendors", vendors_path

    # Sort vendors
    @vendors = sort_vendors().page params[:page]
    # Search vendors
    @vendors = search_vendors(@vendors) if params[:search].present?
  end

  # GET /vendors/1 or /vendors/1.json
  def show
    add_breadcrumb "Vendors", vendors_path
    add_breadcrumb @vendor.get_name, vendor_path(@vendor)

    # Fetch all vendor reviews
    @vendor = Vendor.find(params[:id])
    # Fetch only the reviews that belong to the selected vendor
    @vendor_reviews = @vendor.vendor_reviews.order(created_at: :desc).page(params[:page]).per(2)
    @reviews_start_index = calculate_review_index(params[:page], 2)
  end

  # GET /vendors/new
  def new
    add_breadcrumb "Vendors", vendors_path
    add_breadcrumb "New Vendor", new_vendor_path
    @vendor = Vendor.new
  end

  # GET /vendors/1/edit
  def edit
    add_breadcrumb "Vendors", vendors_path
    add_breadcrumb @vendor.get_name, vendor_path(@vendor)
    add_breadcrumb "Edit", edit_vendor_path(@vendor)
  end

  # GET /vendors/1/review
  def review
    add_breadcrumb "Vendors", vendors_path
    add_breadcrumb @vendor.get_name, vendor_path(@vendor)
    add_breadcrumb "Review", review_vendor_path(@vendor)
  end

  # POST /vendors or /vendors.json
  def create
    @vendor = Vendor.new(vendor_params)

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to vendor_url(@vendor), notice: "Vendor was successfully created." }
        format.json { render :show, status: :created, location: @vendor }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendors/1 or /vendors/1.json
  def update
    add_breadcrumb "Vendors", vendors_path
    add_breadcrumb @vendor.get_name, vendor_path(@vendor)
    add_breadcrumb "Edit", edit_vendor_path(@vendor)

    respond_to do |format|
      if @vendor.update(vendor_params)
        format.html { redirect_to vendor_url(@vendor), notice: "Vendor was successfully updated." }
        format.json { render :show, status: :ok, location: @vendor }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1 or /vendors/1.json
  def destroy
    @vendor.destroy

    respond_to do |format|
      format.html { redirect_to vendors_url, notice: "Vendor was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vendor_params
      params.require(:vendor).permit(:name)
    end

    def sort_vendors
      # Sorts by the query string parameter "sort"
      asc = params[:order] ? params[:order] : "asc"
      vendors = params[:sort] ? Vendor.order(params[:sort] => asc.to_sym) : Vendor.order(created_at: :asc)
    end

    def search_vendors(vendors)
      # Search by the query string parameter "search"
      # Search in "name"
      vendors.where("name LIKE ?", "%#{params[:search]}%")
    end

    def calculate_review_index(page, per_page)
      page_number = page.to_i > 0 ? page.to_i : 1
      per_page_number = per_page.to_i > 0 ? per_page.to_i : 1
      (page_number - 1) * per_page_number
    end
end

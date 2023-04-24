class VendorReviewsController < ApplicationController
    def create
      @vendor = Vendor.find(params[:vendor_id])
      @vendor_review = @vendor.vendor_reviews.new(vendor_review_params)
      @vendor_review.user = current_user
  
      respond_to do |format|
        if @vendor_review.save
          format.html { redirect_to vendor_url(@vendor), notice: "Review was successfully saved." }
          format.json { render :show, status: :created, location: @vendor }
        else
          # TODO: Fix this
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @vendor_review.errors, status: :unprocessable_entity }
        end
      end
    end
  
    private
  
    def vendor_review_params
      params.require(:vendor_review).permit(:rating, :description)
    end
  end
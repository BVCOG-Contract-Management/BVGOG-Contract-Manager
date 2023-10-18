# frozen_string_literal: true

class VendorReviewsController < ApplicationController
    before_action :set_vendor, only: [:create]

    def create
        @vendor = Vendor.find(params[:vendor_id])
        @vendor_review = @vendor.vendor_reviews.new(vendor_review_params)
        @vendor_review.user = current_user

        # Check if the user has already reviewed this vendor
        existing_review = @vendor_review.user.vendor_reviews.find_by(vendor_id: @vendor_review.vendor_id)
        if existing_review.present?
            redirect_to vendor_url(@vendor), alert: 'You have already reviewed this vendor.'
            return
        end

        respond_to do |format|
            if @vendor_review.description.blank?
                format.html { redirect_to new_vendor_vendor_review_path(@vendor), alert: "Description can't be blank." }
                format.json { render json: { error: "Description can't be blank." }, status: :unprocessable_entity }
            elsif @vendor_review.description.length > 2048
                format.html do
                    redirect_to new_vendor_vendor_review_path(@vendor),
                                alert: "Description can't be more than 2048 characters."
                end
                format.json do
                    render json: { error: "Description can't be more than 2048 characters." },
                           status: :unprocessable_entity
                end
            elsif @vendor_review.save
                format.html { redirect_to vendor_url(@vendor), notice: 'Review was successfully saved.' }
                format.json { render :show, status: :created, location: @vendor }
            end
        end
    end

    private

    def vendor_review_params
        params.require(:vendor_review).permit(:rating, :description)
    end

    def set_vendor
        @vendor = Vendor.find(params[:vendor_id])
    end
end

class PagesController < ApplicationController
  def home
  end
  def vendors
    debugger
    @vendors = Vendor.joins(VendorReview)
                            .group(:name)
                            .select('vendors.name, AVG(vendor_reviews.rating) as average_rating')
  end
end

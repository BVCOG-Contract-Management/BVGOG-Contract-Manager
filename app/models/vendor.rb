class Vendor < ApplicationRecord
  has_many :vendor_reviews, class_name: "VendorReview"
end

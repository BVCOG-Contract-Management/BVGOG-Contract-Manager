class Vendor < ApplicationRecord
  has_many :vendor_reviews, class_name: "VendorReview"
  has_many :contracts, class_name: "Contract"
end

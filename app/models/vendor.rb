class Vendor < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }

  has_many :vendor_reviews, class_name: "VendorReview"
  has_many :contracts, class_name: "Contract"

  attribute :average_rating, :float, default: 0.0
end

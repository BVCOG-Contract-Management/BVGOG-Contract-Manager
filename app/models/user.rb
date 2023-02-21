class User < ApplicationRecord
  # Add associations here
  has_one :redirect_user, class_name: "User", foreign_key: "redirect_user_id"
  has_many :contracts, class_name: "Contract", foreign_key: "point_of_contact_id"
  has_many :vendor_reviews, class_name: "VendorReview", foreign_key: "user_id"
end

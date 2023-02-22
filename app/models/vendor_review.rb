class VendorReview < ApplicationRecord
  validates :user_id, presence: true
  validates :vendor_id, presence: true
  validates :rating, presence: true
  validates :description, length: { maximum: 2048 }

  belongs_to :user
  belongs_to :vendor
end

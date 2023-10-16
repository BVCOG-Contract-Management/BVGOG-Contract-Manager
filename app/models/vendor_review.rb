# frozen_string_literal: true

class VendorReview < ApplicationRecord
  validates :user_id, presence: true
  validates :vendor_id, presence: true
  validates :rating, presence: true,
                     numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :description, length: { maximum: 2048 }

  belongs_to :user
  belongs_to :vendor
end

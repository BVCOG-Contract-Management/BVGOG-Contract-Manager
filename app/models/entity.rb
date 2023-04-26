class Entity < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }

  has_many :contracts, class_name: "Contract"

  has_and_belongs_to_many :users
end

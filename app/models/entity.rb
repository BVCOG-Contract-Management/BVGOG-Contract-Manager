class Entity < ApplicationRecord
    validates :name, presence: true, length: { maximum: 255 }

    has_many :contracts, class_name: "Contract"
end

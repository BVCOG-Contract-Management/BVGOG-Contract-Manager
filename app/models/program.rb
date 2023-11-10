# frozen_string_literal: true

class Program < ApplicationRecord
    validates :name, presence: true, length: { maximum: 255 }

    has_many :contracts, class_name: 'Contract'
    has_many :users, class_name: 'User'
end

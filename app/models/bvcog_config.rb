# frozen_string_literal: true

class BvcogConfig < ApplicationRecord
  validates :contracts_path, presence: true
  validates :reports_path, presence: true

  has_and_belongs_to_many :users
end

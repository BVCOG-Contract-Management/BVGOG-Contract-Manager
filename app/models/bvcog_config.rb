class BvcogConfig < ApplicationRecord
    validates :contracts_path, presence: true
    validates :reports_path, presence: true
end

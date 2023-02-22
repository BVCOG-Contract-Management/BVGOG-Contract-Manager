class ContractDocument < ApplicationRecord
validates :contract_id, presence: true
validates :file_name, presence: true
validates :full_path, presence: true

  belongs_to :contract, class_name: "Contract", foreign_key: "contract_id"
end

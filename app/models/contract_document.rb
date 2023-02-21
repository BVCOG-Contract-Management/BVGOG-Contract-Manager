class ContractDocument < ApplicationRecord
  belongs_to :contract, class_name: 'Contract', foreign_key: 'contract_id'
end

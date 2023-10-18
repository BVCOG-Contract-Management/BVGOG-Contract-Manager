# frozen_string_literal: true

class ContractDocument < ApplicationRecord
    validates :contract_id, presence: true
    validates :file_name, presence: true
    validates :full_path, presence: true

    has_enumeration_for :document_type, with: ContractDocumentType, create_helpers: true

    belongs_to :contract, class_name: 'Contract'
end

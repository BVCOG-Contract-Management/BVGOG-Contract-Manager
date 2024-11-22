# frozen_string_literal: true

class ContractDocument < ApplicationRecord
    validates :contract_id, presence: true
    validates :file_name, presence: true
    validates :full_path, presence: true

    has_enumeration_for :document_type, with: ContractDocumentType, create_helpers: true

    belongs_to :contract, class_name: 'Contract'

    # Check if the document is pending
    def pending?
        status == 'pending'
    end

    # Check if the document is approved
    def approved?
        status == 'approved'
    end
end

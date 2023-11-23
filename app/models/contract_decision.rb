# frozen_string_literal: true

class ContractDecision < ApplicationRecord
    validates :contract_id, presence: true
    validates :user_id, presence: true
    validates :reason, length: { maximum: 2048 }
    validates :decision, inclusion: { in: ContractStatus.list }

    belongs_to :contract
    belongs_to :user
end

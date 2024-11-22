# frozen_string_literal: true

class ModificationLog < ApplicationRecord
    belongs_to :contract
    belongs_to :modified_by, class_name: 'User'

    validates :modification_type, :changes_made, :status, presence: true
    validates :modification_type, inclusion: { in: %w[renew amend] }
    validates :status, inclusion: { in: %w[pending approved rejected] }
    # TODO: Add 'approved by' or 'rejected by' fields?

    def reject_amend_notification
        ContractMailer.email_reject_amend(self).deliver_now
    end

    def void_amend_notification
        ContractMailer.email_void_amend(self).deliver_now
    end

    serialize :changes_made, Hash
end

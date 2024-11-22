# frozen_string_literal: true

# Contracts
class Contract < ApplicationRecord
    validates :title, presence: true, length: { maximum: 255 }
    validates :description, length: { maximum: 2048 }
    validates :entity_id, presence: true
    validates :program_id, presence: true
    validates :point_of_contact_id, presence: true
    validates :vendor_id, presence: true
    validates :starts_at, presence: true
    validates :ends_at, comparison: { greater_than_or_equal_to: :starts_at }, if: -> { end_trigger == 'limited_term' }

    validates :total_amount, numericality: { greater_than_or_equal_to: 0 }
    validates :contract_type, presence: true, inclusion: { in: ContractType.list }
    validates :contract_status, inclusion: { in: ContractStatus.list }

    validates :contract_value,
              numericality: { less_than_or_equal_to: 99_000_000, allow_nil: true }

    validates :contract_value,
              numericality: { greater_than_or_equal_to: 0, allow_nil: true }

    validates :current_type, presence: true, inclusion: { in: %w[contract renew amend] }

    belongs_to :entity, class_name: 'Entity'
    belongs_to :program, class_name: 'Program'
    belongs_to :point_of_contact, class_name: 'User'
    belongs_to :vendor, class_name: 'Vendor'
    has_many :contract_documents, class_name: 'ContractDocument'
    has_many :decisions, class_name: 'ContractDecision'
    has_many :modification_logs, class_name: 'ModificationLog'

    serialize :documents_added, Array # Optional, depending on DB adapter

    # Enums
    has_enumeration_for :contract_type, with: ContractType, create_helpers: true
    has_enumeration_for :contract_status, with: ContractStatus, create_helpers: true
    has_enumeration_for :amount_duration, with: TimePeriod, create_helpers: true
    has_enumeration_for :end_trigger, with: EndTrigger, create_helpers: true

    # Methods
    # Deprecated
    # :nocov:
    def send_expiry_reminder
        ContractMailer.expiry_reminder(self).deliver_now
    end
    # :nocov:

    # Deprecated
    # :nocov:
    def expired?
        ends_at < Time.zone.today or ends_at_final < Time.zone.today
    end
    # :nocov:

    def hard_rejected?
        latest_decision = decisions.order(created_at: :desc).first
        latest_decision&.reason&.include?('Hard rejected')
    end

    public :send_expiry_reminder
end

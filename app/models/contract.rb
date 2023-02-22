class Contract < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :entity_id, presence: true
  validates :program_id, presence: true
  validates :point_of_contact_id, presence: true
  validates :vendor_id, presence: true
  validates :contract_type, presence: true
  validates :starts_at, presence: true

  belongs_to :entity, class_name: "Entity", foreign_key: "entity_id"
  belongs_to :program, class_name: "Program", foreign_key: "program_id"
  belongs_to :point_of_contact, class_name: "User", foreign_key: "point_of_contact_id"
  belongs_to :vendor, class_name: "Vendor", foreign_key: "vendor_id"
  has_many :contract_documents, class_name: "ContractDocument"

  # Enums
  has_enumeration_for :contract_type, with: ContractType, create_helpers: true
  has_enumeration_for :contract_status, with: ContractStatus, create_helpers: true
  has_enumeration_for :amount_duration, with: TimePeriod, create_helpers: true
  has_enumeration_for :initial_term_duration, with: TimePeriod, create_helpers: true
  has_enumeration_for :end_trigger, with: EndTrigger, create_helpers: true
end

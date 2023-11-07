
class Contract < ApplicationRecord
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 2048 }
  validates :key_words, length: { maximum: 2048 }
  validates :entity_id, presence: true
  validates :program_id, presence: true
  validates :point_of_contact_id, presence: true
  validates :vendor_id, presence: true
  validates :starts_at, presence: true
  validates :ends_at, comparison: { greater_than_or_equal_to: :starts_at }, if: -> { end_trigger == "limited_term" }
  validates :ends_at_final, comparison: { greater_than_or_equal_to: :ends_at }, if: -> { end_trigger == "limited_term" }

  validates :amount_dollar, numericality: { greater_than_or_equal_to: 0 }
  validates :initial_term_amount, numericality: { greater_than_or_equal_to: 0 }
  validates :contract_type, presence: true, inclusion: { in: ContractType.list }
  validates :contract_status, inclusion: { in: ContractStatus.list }
  validates :amount_duration, inclusion: { in: TimePeriod.list }
  validates :initial_term_duration, inclusion: { in: TimePeriod.list }
  
  validates :end_trigger, inclusion: { in: EndTrigger.list }

  validates :renewal_count, numericality: { greater_than_or_equal_to: 0, less_that_or_equal_to: :max_renewal_count}, if: -> {end_trigger == "limited_term"}
  validates :max_renewal_count, numericality: { greater_than_or_equal_to: :renewal_count }, if: -> {end_trigger == "limited_term"}
  validates :renewal_duration, numericality: { greater_than_or_equal_to: 0 }, if: -> {end_trigger == "limited_term"}
  validates :renewal_duration_units, inclusion: { in: TimePeriod.list }, if: -> {end_trigger == "limited_term"}

  validates :extension_count, numericality: { greater_than_or_equal_to: 0, less_that_or_equal_to: :max_extension_count}, if: -> {end_trigger == "limited_term"}
  validates :max_extension_count, numericality: { greater_than_or_equal_to: :extension_count }, if: -> {end_trigger == "limited_term"}
  validates :extension_duration, numericality: { greater_than_or_equal_to: 0 }, if: -> {end_trigger == "limited_term"}
  validates :extension_duration_units, inclusion: { in: TimePeriod.list }, if: -> {end_trigger == "limited_term"}

  belongs_to :entity, class_name: 'Entity', foreign_key: 'entity_id'
  belongs_to :program, class_name: 'Program', foreign_key: 'program_id'
  belongs_to :point_of_contact, class_name: 'User', foreign_key: 'point_of_contact_id'
  belongs_to :vendor, class_name: 'Vendor', foreign_key: 'vendor_id'
  has_many :contract_documents, class_name: 'ContractDocument'

  # Enums
  has_enumeration_for :contract_type, with: ContractType, create_helpers: true
  has_enumeration_for :contract_status, with: ContractStatus, create_helpers: true
  has_enumeration_for :amount_duration, with: TimePeriod, create_helpers: true
  has_enumeration_for :initial_term_duration, with: TimePeriod, create_helpers: true
  has_enumeration_for :end_trigger, with: EndTrigger, create_helpers: true

  # Methods
  def send_expiry_reminder
    ContractMailer.expiry_reminder(self).deliver_now
  end

  def expired?
    #TODO Verify this behavior.
    ends_at < Date.today or final_ends_at < Date.today
  end

  public :send_expiry_reminder
end

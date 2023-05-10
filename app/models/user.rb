
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }
  validates :encrypted_password, presence: true
  validates :level, presence: true, inclusion: { in: UserLevel.list, allow_blank: false }
  validates :is_program_manager, inclusion: { in: [true, false], allow_blank: false }
  validates :is_active, inclusion: { in: [true, false], allow_blank: false }
  validates :program_id, presence: true

  # Add associations here
  has_and_belongs_to_many :entities

  has_one :redirect_user, class_name: "User", foreign_key: "redirect_user_id"
  has_many :contracts, class_name: "Contract", foreign_key: "point_of_contact_id"
  has_many :vendor_reviews, class_name: "VendorReview", foreign_key: "user_id"

  # TODO: Should the program be optional?
  belongs_to :program, class_name: "Program", foreign_key: "program_id"

  attr_accessor :old_name

  def full_name
    if first_name.present? && last_name.present?
      @old_name = "#{first_name} #{last_name}"
    end
    @old_name
  end

  def has_entity?(entity_id)
    self.entities.where(id: entity_id).exists?
  end
  # Virtual attribute to calculate integer level on the fly
  def level_int
    case level
    when 'one'
      1
    when 'two'
      2
    when 'three'
      3
    else
      nil
    end
  end
end

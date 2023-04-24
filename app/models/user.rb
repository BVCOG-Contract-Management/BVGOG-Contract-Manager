class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, length: { maximum: 255 }
  validates :encrypted_password, presence: true
  validates :level, presence: true, inclusion: { in: UserLevel.list, allow_blank: false }

  # Add associations here
  has_one :redirect_user, class_name: "User", foreign_key: "redirect_user_id"
  has_many :contracts, class_name: "Contract", foreign_key: "point_of_contact_id"
  has_many :vendor_reviews, class_name: "VendorReview", foreign_key: "user_id"
  # TODO: Should the program be optional?
  belongs_to :program, class_name: "Program", foreign_key: "program_id", optional: true

  attr_accessor :old_name

  def full_name
    if first_name.present? && last_name.present?
      @old_name = "#{first_name} #{last_name}"
    end
    @old_name
  end
end

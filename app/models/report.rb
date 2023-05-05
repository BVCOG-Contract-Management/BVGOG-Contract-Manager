class Report < ApplicationRecord

    EXPIRATION_OPTIONS = [30, 60, 90]

    validates :title, presence: true

    has_enumeration_for :report_type, with: ReportType, create_helpers: true
    
    # Associations (Dependent on contract report or user reports)
    has_many :contracts 
    # No need to associate users since all users shown in a users report

    alias_attribute :created_by, :user_id
end
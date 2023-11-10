# frozen_string_literal: true

class CreateVendorReviews < ActiveRecord::Migration[7.0]
    def change
        create_table :vendor_reviews do |t|
            t.float :rating, null: false
            t.text :description
            t.references :user, null: false, foreign_key: true
            t.references :vendor, null: false, foreign_key: true

            # (user, vendor) pair must be unique
            t.index %i[user_id vendor_id], unique: true

            t.timestamps
        end
    end
end

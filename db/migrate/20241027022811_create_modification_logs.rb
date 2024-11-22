# frozen_string_literal: true

class CreateModificationLogs < ActiveRecord::Migration[6.1]
    def change
        create_table :modification_logs do |t|
            t.references :contract, null: false, foreign_key: true # Reference to the contract
            t.string :modified_by, null: false                        # User requesting the modification
            t.string :approved_by                                     # User approving the modification
            t.string :modification_type, null: false                  # Type of modification, e.g., 'renew' or 'amend'
            t.text :changes_made, null: false                         # The content of the requested modification (stored in text format)
            t.string :status, null: false, default: 'pending'         # Status of the modification request, e.g., 'pending', 'approved', 'rejected'
            t.text :remarks                                           # Remarks, such as approval comments or rejection reasons
            t.datetime :modified_at                                   # Time when the modification actually took effect

            t.timestamps
        end
    end
end

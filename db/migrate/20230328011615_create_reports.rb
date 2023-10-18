# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[7.0]
    def change
        create_table :reports do |t|
            # Attributes
            t.text :title, null: false
            t.text :file_name, null: false
            t.text :full_path, null: false

            # Filters (Contract Report)
            t.references :entity, null: true, foreign_key: { to_table: :entities }
            t.references :program, null: true, foreign_key: { to_table: :programs }
            t.references :point_of_contact, null: true, foreign_key: { to_table: :users }
            t.integer :expiring_in_days, null: true

            # Enums
            t.text :report_type, null: false

            t.timestamps
        end
    end
end

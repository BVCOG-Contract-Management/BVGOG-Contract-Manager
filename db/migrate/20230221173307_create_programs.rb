# frozen_string_literal: true

class CreatePrograms < ActiveRecord::Migration[7.0]
    def change
        create_table :programs do |t|
            t.text :name, null: false, index: { unique: true }

            t.timestamps
        end
    end
end

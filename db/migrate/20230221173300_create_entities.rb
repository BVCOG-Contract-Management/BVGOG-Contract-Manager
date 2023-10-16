# frozen_string_literal: true

class CreateEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :entities do |t|
      t.text :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end

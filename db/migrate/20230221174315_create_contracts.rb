class CreateContracts < ActiveRecord::Migration[7.0]
  def change
    create_table :contracts do |t|
      t.text :title, null: false
      t.text :number
      t.references :entity, null: false, foreign_key: { to_table: :entities }
      t.references :program, null: false, foreign_key: { to_table: :programs }
      t.references :point_of_contact, null: false, foreign_key: { to_table: :users }
      t.references :vendor, null: false, foreign_key: { to_table: :vendors }
      t.text :description
      t.text :key_words
      t.float :amount_dollar
      t.datetime :starts_at, null: false
      t.integer :initial_term_amount
      t.datetime :ends_at
      t.boolean :requires_rebid

      # Enums
      t.text :contract_type, null: false
      t.text :contract_status
      t.text :amount_duration
      t.text :initial_term_duration
      t.text :end_trigger

      t.timestamps
    end
  end
end

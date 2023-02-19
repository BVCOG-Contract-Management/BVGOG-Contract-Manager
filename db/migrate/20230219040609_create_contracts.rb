class CreateContracts < ActiveRecord::Migration[7.0]
  def change
    create_table :contracts do |t|
      t.string :title
      t.string :number
      t.integer :entity_id
      t.integer :program_id
      t.integer :point_of_contact_id
      t.integer :status
      t.integer :vendor_id
      t.integer :contract_type
      t.string :description
      t.string :key_words
      t.float :amount_dollar
      t.integer :amount_duration
      t.datetime :start_date
      t.string :initial_term_amount
      t.string :initial_term_duration
      t.datetime :end_date
      t.integer :end_trigger
      t.boolean :requires_rebid, default: false

      t.timestamps
    end

    add_index :contracts, :entity_id
    add_index :contracts, :program_id
    add_index :contracts, :point_of_contact_id
    add_index :contracts, :vendor_id
  end
end

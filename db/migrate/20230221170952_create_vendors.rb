class CreateVendors < ActiveRecord::Migration[7.0]
  def change
    create_table :vendors do |t|
      t.text :name, null: false

      t.timestamps
    end
  end
end

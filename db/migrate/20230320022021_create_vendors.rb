class CreateVendors < ActiveRecord::Migration[7.0]
  def change
    create_table :vendors do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end

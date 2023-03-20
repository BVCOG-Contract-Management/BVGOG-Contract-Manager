class AddNameToVendors < ActiveRecord::Migration[7.0]
  def change
    add_column :vendors, :name, :string
  end
end

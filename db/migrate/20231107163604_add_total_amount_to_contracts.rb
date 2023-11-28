class AddTotalAmountToContracts < ActiveRecord::Migration[7.0]
  def change
    add_column :contracts, :totalamount, :float
  end
end

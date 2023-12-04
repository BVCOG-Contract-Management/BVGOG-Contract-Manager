class AddTotalAmountToContracts < ActiveRecord::Migration[7.0]
  def change
    add_column :contracts, :total_amount, :float
    add_column :contracts, :value_type, :string
  end
end

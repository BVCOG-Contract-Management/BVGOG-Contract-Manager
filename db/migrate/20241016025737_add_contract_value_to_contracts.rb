# frozen_string_literal: true

class AddContractValueToContracts < ActiveRecord::Migration[6.0]
    def change
        # Remove the existing column if it already exists
        remove_column :contracts, :contract_value, :decimal if column_exists?(:contracts, :contract_value)

        # Re-add the column with the new parameters
        add_column :contracts, :contract_value, :decimal, precision: 15, scale: 2
    end
end

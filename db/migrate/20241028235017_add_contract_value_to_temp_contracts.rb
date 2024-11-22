# frozen_string_literal: true

class AddContractValueToTempContracts < ActiveRecord::Migration[6.0]
    def change
        remove_column :temp_contracts, :contract_value, :decimal if column_exists?(:temp_contracts, :contract_value)

        add_column :temp_contracts, :contract_value, :decimal, precision: 15, scale: 2
    end
end

# frozen_string_literal: true

class AddTotalAmountAndValueTypeToTempContracts < ActiveRecord::Migration[7.0]
    def change
        add_column :temp_contracts, :total_amount, :float
        add_column :temp_contracts, :value_type, :string
    end
end

# frozen_string_literal: true

class AddRenewalCountToTempContracts < ActiveRecord::Migration[7.0]
    def change
        add_column :temp_contracts, :renewal_count, :integer, default: 1
    end
end

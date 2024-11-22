# frozen_string_literal: true

class AddExtensionsToTempContracts < ActiveRecord::Migration[7.0]
    def change
        add_column :temp_contracts, :ends_at_final, :date
        rename_column :temp_contracts, :renewal_count, :extension_count
        add_column :temp_contracts, :extension_duration, :integer
        add_column :temp_contracts, :extension_duration_units, :string
    end
end

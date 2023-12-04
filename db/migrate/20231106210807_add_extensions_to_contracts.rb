# frozen_string_literal: true

class AddExtensionsToContracts < ActiveRecord::Migration[7.0]
    def change
        add_column :contracts, :ends_at_final, :date
        rename_column  :contracts, :renewal_count, :extension_count
        add_column :contracts, :extension_duration, :integer
        add_column :contracts, :extension_duration_units, :string
    end
end

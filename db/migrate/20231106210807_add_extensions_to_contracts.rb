# frozen_string_literal: true

class AddExtensionsToContracts < ActiveRecord::Migration[7.0]
    def change
        add_column :contracts, :ends_at_final, :date
        add_column :contracts, :extension_count, :integer
        add_column :contracts, :max_extension_count, :integer
        add_column :contracts, :extension_duration, :integer
        add_column :contracts, :extension_duration_units, :string
    end
end

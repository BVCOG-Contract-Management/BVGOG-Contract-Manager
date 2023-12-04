class AddRenewalCountToContracts < ActiveRecord::Migration[7.0]
    def change
        add_column :contracts, :renewal_count, :integer, default: 1
    end
end
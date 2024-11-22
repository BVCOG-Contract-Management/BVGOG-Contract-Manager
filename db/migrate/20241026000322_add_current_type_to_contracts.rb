# frozen_string_literal: true

class AddCurrentTypeToContracts < ActiveRecord::Migration[7.0]
    def change
        add_column :contracts, :current_type, :string, default: 'contract'
        reversible do |dir|
            dir.up do
                execute "UPDATE contracts SET current_type = 'contract' WHERE current_type IS NULL"
            end
        end
    end
end

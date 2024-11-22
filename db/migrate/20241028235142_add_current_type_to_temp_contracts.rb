# frozen_string_literal: true

class AddCurrentTypeToTempContracts < ActiveRecord::Migration[7.0]
    def change
        add_column :temp_contracts, :current_type, :string, default: 'contract'

        reversible do |dir|
            dir.up do
                execute "UPDATE temp_contracts SET current_type = 'contract' WHERE current_type IS NULL"
            end
        end
    end
end

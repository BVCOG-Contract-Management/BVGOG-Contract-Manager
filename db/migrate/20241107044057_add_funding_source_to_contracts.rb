# frozen_string_literal: true

class AddFundingSourceToContracts < ActiveRecord::Migration[7.0]
    def change
        add_column :contracts, :funding_source, :string
    end
end

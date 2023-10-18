# frozen_string_literal: true

class AddShowExpiredContractsToReports < ActiveRecord::Migration[7.0]
    def change
        add_column :reports, :show_expired_contracts, :boolean, default: false
    end
end

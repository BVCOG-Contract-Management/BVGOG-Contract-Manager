# frozen_string_literal: true

class AddDocumentsAddedToContracts < ActiveRecord::Migration[7.0]
    def change
        add_column :contracts, :documents_added, :json
    end
end

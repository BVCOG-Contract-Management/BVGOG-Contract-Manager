# frozen_string_literal: true

class AddStatusToContractDocuments < ActiveRecord::Migration[7.0]
    def change
        add_column :contract_documents, :status, :string
    end
end

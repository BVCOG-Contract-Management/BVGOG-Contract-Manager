# frozen_string_literal: true

class AddOrigFileNameToContractDocuments < ActiveRecord::Migration[7.0]
    def change
        add_column :contract_documents, :orig_file_name, :text
    end
end

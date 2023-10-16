# frozen_string_literal: true

class AddDocumentTypeToContractDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :contract_documents, :document_type, :text, allow_nil: true
  end
end

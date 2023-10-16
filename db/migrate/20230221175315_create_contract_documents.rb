# frozen_string_literal: true

class CreateContractDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :contract_documents do |t|
      t.text :file_name, null: false
      t.text :full_path, null: false

      t.references :contract, null: false, foreign_key: { to_table: :contracts }

      t.timestamps
    end
  end
end

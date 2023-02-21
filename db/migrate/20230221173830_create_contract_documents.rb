class CreateContractDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :contract_documents do |t|
      t.text :file_name
      t.text :full_path
      
      t.references :contract, null: false, foreign_key: { to_table: :contracts }

      t.timestamps
    end
  end
end

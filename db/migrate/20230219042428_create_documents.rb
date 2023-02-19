class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents do |t|
      t.string :file_name
      t.text :path
      t.integer :contract_id
      t.timestamps
    end

    add_index :documents, :contract_id
  end
end

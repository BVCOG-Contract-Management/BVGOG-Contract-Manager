class CreateContractStatusTable < ActiveRecord::Migration[7.0]
  def change
    create_table :contract_status_tables do |t|
      t.text :contract_id, null: false
      t.string :description, null: false
      t.text :decision, null: false, default: ContractStatus::in_progress

      t.timestamps
    end
  end
end

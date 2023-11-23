# frozen_string_literal: true

class CreateContractStatusTable < ActiveRecord::Migration[7.0]
    def change
        create_table :contract_decisions do |t|
            t.references :contract, null: false, foreign_key: { to_table: :contracts }
            t.references :user, null: false, foreign_key: { to_table: :users }
            t.string :reason
            t.text :decision, null: false, default: ContractStatus::IN_PROGRESS

            t.timestamps
        end
    end
end

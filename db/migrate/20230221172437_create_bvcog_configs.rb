# frozen_string_literal: true

class CreateBvcogConfigs < ActiveRecord::Migration[7.0]
    def change
        create_table :bvcog_configs do |t|
            t.text :contracts_path, null: false
            t.text :reports_path, null: false

            t.timestamps
        end
    end
end

class CreateAppConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :app_configs do |t|
      t.text :contracts_path

      t.timestamps
    end
  end
end

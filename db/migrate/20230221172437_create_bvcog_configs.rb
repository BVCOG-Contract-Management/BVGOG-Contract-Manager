class CreateBvcogConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :bvcog_configs do |t|
      t.text :contracts_path

      t.timestamps
    end
  end
end

class CreateAppConfig < ActiveRecord::Migration[7.0]
  def change
    create_table :app_configs do |t|
      t.string :path
      t.timestamps
    end
  end
end

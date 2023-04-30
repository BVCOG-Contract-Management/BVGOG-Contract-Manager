class CreateBvcogConfigsUsersJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_table :bvcog_configs_users, id: false do |t|
      t.belongs_to :bvcog_config
      t.belongs_to :user
    end
  end
end

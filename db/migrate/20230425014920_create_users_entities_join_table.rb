class CreateUsersEntitiesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :entities do |t|
      t.index :user_id
      t.index :entity_id
    end
  end
end

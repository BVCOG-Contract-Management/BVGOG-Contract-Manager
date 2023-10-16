# frozen_string_literal: true

class CreateEntitiesUsersJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table :entities_users, id: false do |t|
      t.belongs_to :entity
      t.belongs_to :user
    end

    add_index :entities_users, %i[entity_id user_id], unique: true
  end
end

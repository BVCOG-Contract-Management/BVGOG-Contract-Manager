# frozen_string_literal: true

class RemoveEmailAndPasswordFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :password, :text
    remove_column :users, :email, :text
  end
end

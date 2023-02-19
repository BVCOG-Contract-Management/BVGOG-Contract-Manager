class CreateUser < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :full_name
      t.integer :level
      #Created_at is automatically created when the user is created by rails
      t.timestamps
    end
  end
end

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :program_id
      t.boolean :program_manager
      t.boolean :status
      t.integer :redirect_user_id
      t.integer :level

      t.timestamps
    end
  end
end

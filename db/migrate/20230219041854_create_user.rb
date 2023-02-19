class CreateUser < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :program_id
      t.program_manager :boolean, default: false
      t.status :boolean, default: false
      t.integer :redirect_user_id
      t.integer :level
      #Created_at is automatically created when the user is created by rails
      t.timestamps
    end
  end
end

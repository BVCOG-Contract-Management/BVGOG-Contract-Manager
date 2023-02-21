class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.text :first_name
      t.text :last_name
      t.text :email
      t.boolean :is_program_manager
      t.boolean :is_active

      # Add self association for redirect user
      t.references :redirect_user, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

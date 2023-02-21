class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.text :first_name, null: false
      t.text :last_name, null: false
      t.text :email, null: false
      t.boolean :is_program_manager, null: false, default: false
      t.boolean :is_active, null: false, default: true

      # Add self association for redirect user
      t.references :redirect_user, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

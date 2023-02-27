class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.text :first_name, null: false
      t.text :last_name, null: false
      #t.string :email, null: false, index: { unique: true }
      #t.string :encrypted_password, null: false
      t.boolean :is_program_manager, null: false, default: false
      t.boolean :is_active, null: false, default: true
      t.text :level, null: false, default: UserLevel::THREE

      # Add self association for redirect user
      t.references :redirect_user, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end

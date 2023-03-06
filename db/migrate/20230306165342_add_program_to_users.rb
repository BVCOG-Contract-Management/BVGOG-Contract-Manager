class AddProgramToUsers < ActiveRecord::Migration[7.0]
  def change
    # TODO: Remove default
    add_reference :users, :program, null: false, foreign_key: true, default: 1
  end
end

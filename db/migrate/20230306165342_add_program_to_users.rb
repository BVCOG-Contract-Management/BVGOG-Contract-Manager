class AddProgramToUsers < ActiveRecord::Migration[7.0]
  def change
    #TODO: A user has to have a program?
    add_reference :users, :program, null: true, foreign_key: true
  end
end

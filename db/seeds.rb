# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Seed DB with some users.
some_users = [
  {
    :first_name => "John",
    :last_name => "John",
    :email => "john@john",
    :program_id => "",
    :program_manager => "",
    :status => true,
    :redirect_user_id => "",
    :level => 1,
  },
  {
    :first_name => "Anna",
    :last_name => "Smith",
    :email => "anna@smith",
    :program_id => "",
    :program_manager => "",
    :status => true,
    :redirect_user_id => "",
    :level => 2,
  },
]

some_users.each do |user|
  User.create!(user)
end

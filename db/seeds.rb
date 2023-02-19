# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Seed the RottenPotatoes DB with some movies.

Vendor.create!([{name: "Vcorp"}])
Entity.create!([{name: "Test Entity"}])
User.create!([{first_name: "Liam", last_name: "Berney", email: "iamrberney@tamu.edu", level: 0}])

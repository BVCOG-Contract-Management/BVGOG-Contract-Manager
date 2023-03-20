# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


# create 5 vendors with chosen name and average rating
Vendor.create(name: "Vendor A", average_rating: 4.2)
Vendor.create(name: "Vendor B", average_rating: 3.9)
Vendor.create(name: "Vendor C", average_rating: 4.5)
Vendor.create(name: "Vendor D", average_rating: 3.7)
Vendor.create(name: "Vendor E", average_rating: 4.1)
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Seed the RottenPotatoes DB with some movies.

Vendor.create!([{ name: 'Vcorp' }])
Vendor.create!([{ name: 'Scorp' }])
Vendor.create!([{ name: 'Bcorp' }])
Entity.create!([{ name: 'Test Entity' }])
User.create!([{ first_name: 'Liam', last_name: 'Berney', email: 'liamrberney@tamu.edu', level: 0 }])
Program.create!([{ name: 'Test Program' }])
Document.create!([{ file_name: 'Test Document' }])
VendorReview.create!([{ user_id: 0, vendor_id: 1, rating: 5, description: 'Test Review' }])
VendorReview.create!([{ user_id: 0, vendor_id: 2, rating: 5, description: 'Test Review' }])
Contract.create!([{ title: 'Test Contract', number: '1', entity_id: 0, program_id: 0, point_of_contact_id: 0, status: 0,
                    vendor_id: 0, contract_type: 0, description: 'Test Contract Description', key_words: 'Test Key Words', amount_dollar: 10_000, amount_duration: 1 }])

''"                   t.string :title
t.string :number
t.integer :entity_id
t.integer :program_id
t.integer :point_of_contact_id
t.integer :status
t.integer :vendor_id
t.integer :type
t.string :description
t.string :key_words
t.float :amount_dollar
t.integer :amount_duration
t.datetime :start_date
t.string :initial_term_amount
t.string :initial_term_duration
t.datetime :end_date
t.integer :end_trigger
t.boolean :requires_rebid, default: false"''

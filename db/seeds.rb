# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "factory_bot_rails"

# Create users
for i in 1..50
  FactoryBot.create(:user, id: i)
end

# Create entities
for i in 1..5
  FactoryBot.create(
    :entity,
    name: "Entity #{i}",
  )
end

# Create programs
for i in 1..5
  FactoryBot.create(
    :program,
    id: i,
    name: "Program #{i}",
  )
end

# Create vendors
for i in 1..5
  FactoryBot.create(
    :vendor,
    id: i,
    name: "Vendor #{i}",
  )
end

# Create multiple contracts
for i in 1..50
  FactoryBot.create(
    :contract,
    id: i,
    title: "Contract #{i}",
    entity: Entity.all.sample,
    program: Program.all.sample,
    point_of_contact: User.all.sample,
    vendor: Vendor.all.sample,
  )
end

# Create contract documents
for i in 1..500
  FactoryBot.create(
    :contract_document,
    id: i,
    contract: Contract.all.sample,
  )
end

# Create vendor reviews manually since they have a (user, vendor) unique index
used_user_vendor_combos = []
for i in 1..10
  user = User.all.sample
  vendor = Vendor.all.sample
  if used_user_vendor_combos.include?([user.id, vendor.id])
    redo
  end
  FactoryBot.create(
    :vendor_review,
    id: i,
    user: user,
    vendor: vendor,
  )
  used_user_vendor_combos << [user.id, vendor.id]
end

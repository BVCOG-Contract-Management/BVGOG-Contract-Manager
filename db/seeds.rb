# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'factory_bot_rails'

# Redirect stdout to a null device
# orig_stdout = $stdout.clone
# $stdout.reopen(File.new('/dev/null', 'w'))

# Create programs
for i in 1..5
  FactoryBot.create(
    :program,
    id: i,
    name: "Program #{i}"
  )
end

# Create entities
for i in 1..5
  FactoryBot.create(
    :entity,
    id: i,
    name: "Entity #{i}"
  )
end

# Create users
for i in 1..50
  FactoryBot.create(
    :user,
    email: "admin@bvcogdev.com",
    password: "password",
    first_name: "BVCOG",
    last_name: "Dev",
    level: UserLevel::ONE,
    program: Program.first,
    # Invitation already accepted
    invitation_accepted_at: Time.now,
  )
end

FactoryBot.create(
  :user,
  email: 'user@example.com',
  password: 'password',
  first_name: 'Example',
  last_name: 'User',
  program: Program.all.sample,
  entities: Entity.all.sample(rand(0..Entity.count)),
  level: UserLevel.enumeration.except(:zero).keys.sample
)
# Create a level 1 user
FactoryBot.create(
  :user,
  email: 'admin@example.com',
  password: 'password',
  first_name: 'Admin',
  last_name: 'User',
  program: Program.all.sample,
  entities: Entity.all.sample(rand(0..Entity.count)),
  level: UserLevel::ONE
)

# Create vendors
for i in 1..50
  FactoryBot.create(
    :vendor,
    id: i,
    name: "Vendor #{i}"
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
    vendor: Vendor.all.sample
  )
end

contact_person = User.find_by(email: 'user@example.com')
# Create some documents with nearby expiries to test expiring docs mailer
for i in 1..100
  FactoryBot.create(
    :contract,
    id: 50 + i,
    point_of_contact: contact_person,
    title: "Expiry Contract #{i}",
    program: Program.all.sample,
    vendor: Vendor.all.sample,
    entity: Entity.all.sample,
    ends_at: Date.today + 1.days * i
  )
end

# Create contract documents
for i in 1..500
  FactoryBot.create(
    :contract_document,
    id: i,
    contract: Contract.all.sample
  )
end

# Create vendor reviews manually since they have a (user, vendor) unique index
used_user_vendor_combos = []
for i in 1..100
  user = User.all.sample
  vendor = Vendor.all.sample
  redo if used_user_vendor_combos.include?([user.id, vendor.id])
  FactoryBot.create(
    :vendor_review,
    id: i,
    user:,
    vendor:
  )
  used_user_vendor_combos << [user.id, vendor.id]
end

# BVCOG Config
# Create the directories if they don't exist
Dir.mkdir(Rails.root.join('public/contracts')) unless Dir.exist?(Rails.root.join('public/contracts'))
Dir.mkdir(Rails.root.join('public/reports')) unless Dir.exist?(Rails.root.join('public/reports'))

# Create the config
BvcogConfig.create(
  id: 1,
  contracts_path: Rails.root.join('public/contracts'),
  reports_path: Rails.root.join('public/reports')
)

# $stdout.reopen(orig_stdout)

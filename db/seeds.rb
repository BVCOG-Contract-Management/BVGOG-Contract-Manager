# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "factory_bot_rails"

# Create users
for i in 1..5
  FactoryBot.create(:user)
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
    name: "Program #{i}",
  )
end

# Create vendors
for i in 1..5
  FactoryBot.create(
    :vendor,
    name: "Vendor #{i}",
  )
end


# Create multiple contracts
for i in 1..50
  FactoryBot.create(
    :contract,
    title: "Contract #{i}",
    entity: Entity.all.sample,
    program: Program.all.sample,
    point_of_contact: User.all.sample,
    vendor: Vendor.all.sample,
  )
end

# Create contract documents
for i in 1..5
  FactoryBot.create(
    :contract_document,
    contract: Contract.all.sample,
  )
end

# Create vendor reviews
for i in 1..5
    # If a null constraint is violated, retry
    begin
        vendor_review = FactoryBot.create(
            :vendor_review,
            user: User.all.sample,
            vendor: Vendor.all.sample,  
        )   
    rescue ActiveRecord::NotNullViolation
        retry
    end
end
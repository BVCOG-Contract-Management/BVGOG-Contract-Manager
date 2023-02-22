# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "factory_bot_rails"

# Create a user
user = FactoryBot.create(:user, email: "john.doe@email.com", password: "password")

# Create an entity
entity = FactoryBot.create(:entity, name: "Entity 1")

# Create a program
program = FactoryBot.create(:program, name: "Program 1")

# Create a vendor
vendor = FactoryBot.create(:vendor, name: "Vendor 1")

# Create a contract
contract = FactoryBot.create(
    :contract,
    title: "Contract 1",
    entity: entity,
    program: program,
    vendor: vendor,
    point_of_contact: user,
)

# Create contract documents
contract_document = FactoryBot.create(
    :contract_document,
    contract: contract,
    file_name: "contract_doc1.pdf",
    full_path: File.join(Rails.root, "~", "data", "contracts", "contract_document.pdf"),
)

contract_document = FactoryBot.create(
    :contract_document,
    contract: contract,
    file_name: "contract_doc2.pdf",
    full_path: File.join(Rails.root, "~", "data", "contracts", "contract_document.pdf"),
)

# Create vendor reviews
vendor_review = FactoryBot.create(
    :vendor_review,
    vendor: vendor,
    user: user,
    rating: 5,
    description: "This is a vendor review.",
)
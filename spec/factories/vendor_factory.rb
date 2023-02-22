# Vendor Factory

FactoryBot.define do
  factory :vendor do
    id { Faker::Number.positive }
    name { Faker::Company.name }
  end
end

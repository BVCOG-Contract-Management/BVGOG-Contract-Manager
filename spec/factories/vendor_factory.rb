# Vendor Factory

FactoryBot.define do
  factory :vendor do
    name { Faker::Company.name }
  end
end

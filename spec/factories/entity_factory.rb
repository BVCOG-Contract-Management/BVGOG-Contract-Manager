# Entity Factory

FactoryBot.define do
    factory :entity do

      id { Faker::Number.positive }
      name { Faker::Company.name }
    end
  end
  
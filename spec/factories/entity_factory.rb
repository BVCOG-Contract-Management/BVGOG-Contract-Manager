# Entity Factory

FactoryBot.define do
    factory :entity do
      name { Faker::Company.name }
    end
  end
  
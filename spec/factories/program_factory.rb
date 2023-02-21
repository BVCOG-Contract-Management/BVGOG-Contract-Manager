# Program Factory

FactoryBot.define do
    factory :program do
      name { Faker::Company.name }
    end
  end
  
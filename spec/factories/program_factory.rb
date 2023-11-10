# frozen_string_literal: true

# Program Factory

FactoryBot.define do
    factory :program do
        id { Faker::Number.positive }
        name { Faker::Company.name }
    end
end

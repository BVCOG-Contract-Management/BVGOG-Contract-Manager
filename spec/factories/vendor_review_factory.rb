# frozen_string_literal: true

# Vendor Review Factory

FactoryBot.define do
  factory :vendor_review do
    association :vendor, factory: :vendor
    association :user, factory: :user

    id { Faker::Number.positive }
    rating { rand(1..5) }
    description { Faker::Lorem.paragraph(sentence_count: 5) }
  end
end

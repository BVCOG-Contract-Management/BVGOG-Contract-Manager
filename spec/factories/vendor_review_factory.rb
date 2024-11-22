# frozen_string_literal: true

# Vendor Review Factory

FactoryBot.define do
    factory :vendor_review do
        vendor # This automatically associates a vendor using the vendor factory
        user   # Ensure you have a user factory if needed for this association
        id { Faker::Number.positive }
        rating { rand(1..5) }
        description { Faker::Lorem.paragraph(sentence_count: 5) }
    end
end

# Vendor Review Factory

FactoryBot.define do
    factory :vendor_review do
        vendor
        user
        rating { rand(1..5) }
        description { Faker::Lorem.paragraph }
    end
end
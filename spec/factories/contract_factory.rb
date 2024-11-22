# frozen_string_literal: true

# Contract Factory

FactoryBot.define do
    factory :contract do
        association :entity, factory: :entity
        association :program, factory: :program
        association :vendor, factory: :vendor
        association :point_of_contact, factory: :user

        id { Faker::Number.positive }
        title { Faker::Lorem.sentence }
        description { Faker::Lorem.paragraph(sentence_count: 15) }
        total_amount { Faker::Number.between(from: 0, to: 99_000_000) }
        number { Faker::Alphanumeric.alphanumeric(number: 10) }
        requires_rebid { false }

        starts_at { Faker::Date.between(from: 2.years.ago, to: Time.zone.today) }
        # Set date very far in the future to avoid validation errors
        ends_at { Faker::Date.between(from: 20.years.from_now, to: 30.years.from_now) }

        contract_type { ContractType.list.sample }
        contract_status { ContractStatus.list.sample }
    end
end

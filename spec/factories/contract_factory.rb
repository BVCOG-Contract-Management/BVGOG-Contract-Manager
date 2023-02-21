# Contract Factory

FactoryBot.define do
    factory :contract do
        entity
        program
        vendor
        association :point_of_contact, factory: :user
        title { Faker::Lorem.sentence }
        description { Faker::Lorem.paragraph }
        key_words { Faker::Lorem.words }
        amount_dollar { Faker::Number.positive }
        amount_duration { TimePeriod::MONTH }
        initial_term_amount { Faker::Number.positive }
        initial_term_duration { TimePeriod::MONTH }
        number { "123456abcde" }
        requires_rebid { false }

        starts_at { Faker::Date.between(from: 2.years.ago, to: Date.today) }
        ends_at { Faker::Date.between(from: 2.years.ago, to: Date.today) }

        contract_type { ContractType::CONTRACT }
        contract_status { ContractStatus::IN_PROGRESS }
        end_trigger { EndTrigger::LIMITED_TERM }

    end
end
# Contract Factory

FactoryBot.define do
  factory :contract do
    association :entity, factory: :entity
    association :program, factory: :program
    association :vendor, factory: :vendor
    association :point_of_contact, factory: :user

    id { Faker::Number.positive }
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

    # Set date very far in the future to avoid validation errors
    ends_at { Faker::Date.between(from: 20.years.from_now, to: 30.years.from_now) }

    contract_type { ContractType::CONTRACT }
    contract_status { ContractStatus::IN_PROGRESS }
    end_trigger { EndTrigger::LIMITED_TERM }
  end
end

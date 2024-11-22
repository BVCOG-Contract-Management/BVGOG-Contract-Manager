# frozen_string_literal: true

FactoryBot.define do
    factory :report do
        association :user_id, factory: :user

        title { Faker::Lorem.sentence(word_count: 3) }
        report_type { ReportType::CONTRACTS }
    end
end

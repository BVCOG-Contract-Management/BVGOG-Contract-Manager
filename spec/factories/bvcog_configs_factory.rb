# frozen_string_literal: true

# BvcogConfig Factory

FactoryBot.define do
    factory :bvcog_config do
        contracts_path { Faker::File.dir.to_s }
        reports_path { Faker::File.dir.to_s }
    end
end

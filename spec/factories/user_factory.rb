# frozen_string_literal: true

# User Factory

FactoryBot.define do
    factory :user do
        email { Faker::Internet.email }
        password { 'password' }
        first_name { Faker::Name.first_name }
        last_name { Faker::Name.last_name }
        is_program_manager { false }
        is_active { true }
        level { UserLevel::THREE }
        program { Program.all.any? ? Program.all.sample : FactoryBot.create(:program) }
    end
end

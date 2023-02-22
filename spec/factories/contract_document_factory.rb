# Contract Document Factory

FactoryBot.define do
    factory :contract_document do
        association :contract, factory: :contract
        
        id { Faker::Number.positive }
        file_name { Faker::File.file_name }
        full_path { Faker::File.dir + "/" + Faker::File.file_name }
    end
end
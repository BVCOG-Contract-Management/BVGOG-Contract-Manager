# Contract Document Factory

FactoryBot.define do
    factory :contract_document do
        contract
        file_name { Faker::File.file_name }
        full_path { Faker::File.dir + "/" + Faker::File.file_name }
    end
end
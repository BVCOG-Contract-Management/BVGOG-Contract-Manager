# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
    include FactoryBot::Syntax::Methods

    it 'filters contracts based on entity' do
        # Create test data
        entity_one = create(:entity, name: 'Entity 1')
        entity_two = create(:entity, name: 'Entity 2')
        contract_one = create(:contract, entity: entity_one, program: create(:program), vendor: create(:vendor), point_of_contact: create(:user))
        contract_two = create(:contract, entity: entity_two, program: create(:program), vendor: create(:vendor), point_of_contact: create(:user))

        # Invoke the method being tested
        filtered_contracts = described_class.query_filtered_report_contracts(entity: entity_one)

        # Assertion to check if the contracts are filtered based on entity_id
        expect(filtered_contracts).to include(contract_one)
        expect(filtered_contracts).not_to include(contract_two)
    end

    it 'filters contracts based on program' do
        # Create test data
        program_one = create(:program, name: 'Program 1')
        program_two = create(:program, name: 'Program 2')
        contract_one = create(:contract, entity: create(:entity), program: program_one, vendor: create(:vendor), point_of_contact: create(:user))
        contract_two = create(:contract, entity: create(:entity), program: program_two, vendor: create(:vendor), point_of_contact: create(:user))

        # Invoke the method being tested
        filtered_contracts = described_class.query_filtered_report_contracts(program: program_one)

        # Assertion to check if the contracts are filtered based on entity_id
        expect(filtered_contracts).to include(contract_one)
        expect(filtered_contracts).not_to include(contract_two)
    end

    describe '#set_report_file' do
        it 'generates a file name and path for the report' do
            # Write test code here
        end
    end

    describe '#generate_standard_users_report' do
        it 'creates a PDF report with active and inactive users' do
            # Write test code here
        end
    end

    describe '#generate_standard_contracts_report' do
        it 'creates a PDF report with filtered contract details' do
            # Write test code here
        end
    end
end

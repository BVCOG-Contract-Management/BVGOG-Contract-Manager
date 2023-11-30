# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
    include FactoryBot::Syntax::Methods

    describe '#query_filtered_report_contracts' do
        it 'filters contracts based on entity_id' do
            # Create test data
            entity1 = create(:entity, name: 'Entity 1')
            entity2 = create(:entity, name: 'Entity 2')
            contract1 = create(:contract, entity: entity1, program: create(:program), vendor: create(:vendor), point_of_contact: create(:user))
            contract2 = create(:contract, entity: entity2, program: create(:program), vendor: create(:vendor), point_of_contact: create(:user))

            # Invoke the method being tested
            filtered_contracts = described_class.query_filtered_report_contracts(entity: entity1)

            # Assertion to check if the contracts are filtered based on entity_id
            expect(filtered_contracts).to include(contract1)
            expect(filtered_contracts).not_to include(contract2)
        end

        it 'filters contracts based on program_id' do
            # Create test data
            program1 = create(:program, name: 'Program 1')
            program2 = create(:program, name: 'Program 2')
            contract1 = create(:contract, entity: create(:entity), program: program1, vendor: create(:vendor), point_of_contact: create(:user))
            contract2 = create(:contract, entity: create(:entity), program: program2, vendor: create(:vendor), point_of_contact: create(:user))

            # Invoke the method being tested
            filtered_contracts = described_class.query_filtered_report_contracts(program: program1)

            # Assertion to check if the contracts are filtered based on entity_id
            expect(filtered_contracts).to include(contract1)
            expect(filtered_contracts).not_to include(contract2)
        end

        # Write similar tests for other filtering conditions...
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

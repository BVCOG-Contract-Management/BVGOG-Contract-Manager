# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
    include FactoryBot::Syntax::Methods

    let(:bvcog_config) { instance_double(BvcogConfig, reports_path: './') }

    before do
        allow(BvcogConfig).to receive(:last).and_return(bvcog_config)
    end

    it 'filters contracts based on entity' do
        # Create test data
        user = create(:user, id: 3, level: UserLevel::ONE)
        entity_one = create(:entity, name: 'Entity 1')
        entity_two = create(:entity, name: 'Entity 2')
        contract_one = create(:contract, entity: entity_one, program: create(:program), vendor: create(:vendor), point_of_contact: user)
        contract_two = create(:contract, entity: entity_two, program: create(:program), vendor: create(:vendor), point_of_contact: user)

        # Invoke the method being tested
        report = described_class.new(entity_id: entity_one.id, created_by: user.id)
        filtered_contracts = report.query_filtered_report_contracts

        # Assertion to check if the contracts are filtered based on entity_id
        expect(filtered_contracts).to include(contract_one)
        expect(filtered_contracts).not_to include(contract_two)
    end

    it 'filters contracts based on program' do
        # Create test data
        user = create(:user, id: 3, level: UserLevel::ONE)
        program_one = create(:program, name: 'Program 1')
        program_two = create(:program, name: 'Program 2')
        contract_one = create(:contract, entity: create(:entity), program: program_one, vendor: create(:vendor), point_of_contact: user)
        contract_two = create(:contract, entity: create(:entity), program: program_two, vendor: create(:vendor), point_of_contact: user)

        # Invoke the method being tested
        report = described_class.new(program_id: program_one.id, created_by: user.id)
        filtered_contracts = report.query_filtered_report_contracts

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
            # Create test data
            user = create(:user, id: 3, level: UserLevel::ONE)
            program_one = create(:program, name: 'Program 1')
            program_two = create(:program, name: 'Program 2')
            contract_one = create(:contract, entity: create(:entity), program: program_one, vendor: create(:vendor), point_of_contact: user)
            contract_two = create(:contract, entity: create(:entity), program: program_two, vendor: create(:vendor), point_of_contact: user)

            # Invoke the method being tested
            report = described_class.new(program_id: program_one.id, created_by: user.id, title: "Test_report")
            filtered_contracts = report.query_filtered_report_contracts

            # Assertion to check if the contracts are filtered based on entity_id
            expect(filtered_contracts).to include(contract_one)
            expect(filtered_contracts).not_to include(contract_two)

            report.generate_standard_users_report
            expect(File.exist?(report.full_path)).to be_truthy

            File.delete(report.full_path) if File.exist?(report.full_path)
        end
    end

    describe '#generate_standard_contracts_report' do
        it 'creates a PDF report with filtered contract details' do
            # Create test data
            user = create(:user, id: 3, level: UserLevel::ONE)
            program_one = create(:program, name: 'Program 1')
            program_two = create(:program, name: 'Program 2')
            contract_one = create(:contract, entity: create(:entity), program: program_one, vendor: create(:vendor), point_of_contact: user)
            contract_two = create(:contract, entity: create(:entity), program: program_two, vendor: create(:vendor), point_of_contact: user)

            # Invoke the method being tested
            report = described_class.new(program_id: program_one.id, created_by: user.id, title: "Test_report")
            filtered_contracts = report.query_filtered_report_contracts

            # Assertion to check if the contracts are filtered based on entity_id
            expect(filtered_contracts).to include(contract_one)
            expect(filtered_contracts).not_to include(contract_two)

            report.generate_standard_contracts_report
            expect(File.exist?(report.full_path)).to be_truthy

            File.delete(report.full_path) if File.exist?(report.full_path)
        end
    end
end

# frozen_string_literal: true

require 'rails_helper'
require 'auth_helper'
# Specs in this file have access to a helper object that includes
# the ContractsHelper. For example:
#
# describe ContractsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
# RSpec.describe ContractsHelper, type: :helper do
#     pending "add some examples to (or delete) #{__FILE__}"
# end

include ContractsHelper

RSpec.describe ContractsHelper, type: :helper do
    describe '#vendor_select_options_json' do
        it 'returns JSON representation of vendor select options' do
            existing_vendors = Vendor.all
            expected_options = existing_vendors.map { |vendor| { 'label' => vendor.name, 'value' => vendor.id } }
            expected_options.push({ 'label' => 'New Vendor', 'value' => 'new' })
            expect(helper.send(:vendor_select_options_json)).not_to be_empty
            expect(JSON.parse(helper.send(:vendor_select_options_json))).to eq(expected_options)
        end
    end

    describe '#contract_status_icon' do
        let(:contract_created) { FactoryBot.build(:contract, contract_status: ContractStatus::CREATED) }
        let(:contract_in_progress) { FactoryBot.build(:contract, contract_status: ContractStatus::IN_PROGRESS) }
        let(:contract_in_review) { FactoryBot.build(:contract, contract_status: ContractStatus::IN_REVIEW) }
        let(:contract_approved) { FactoryBot.build(:contract, contract_status: ContractStatus::APPROVED) }
        let(:contract_rejected) { FactoryBot.build(:contract, contract_status: ContractStatus::REJECTED) }

        it 'returns the created status tag for a contract in created' do
            expect(helper.contract_status_icon(contract_created)).to include('Created')
            expect(helper.contract_status_icon(contract_created)).to include('is-warning')
        end

        it 'returns the in_progress status tag for a contract in progress' do
            expect(helper.contract_status_icon(contract_in_progress)).to include('In Progress')
            expect(helper.contract_status_icon(contract_in_progress)).to include('is-warning')
        end

        it 'returns the in_review status tag for a contract in review' do
            expect(helper.contract_status_icon(contract_in_review)).to include('In Review')
            expect(helper.contract_status_icon(contract_in_review)).to include('is-warning')
        end

        it 'returns the approved status tag for an approved contract' do
            expect(helper.contract_status_icon(contract_approved)).to include('Approved')
            expect(helper.contract_status_icon(contract_approved)).to include('is-success')
        end

        it 'returns the rejected status tag for an rejected contract' do
            expect(helper.contract_status_icon(contract_rejected)).to include('Rejected')
            expect(helper.contract_status_icon(contract_rejected)).to include('is-danger')
        end
    end

    describe '#file_type_icon' do
        it 'returns the PDF icon for a PDF file' do
            expect(helper.file_type_icon('file.pdf')).to include('fa-file-pdf')
            expect(helper.file_type_icon('file.pdf')).to include('has-text-danger')
        end

        it 'returns the Word icon for a DOCX file' do
            expect(helper.file_type_icon('file.docx')).to include('fa-file-word')
            expect(helper.file_type_icon('file.docx')).to include('has-text-primary')
        end

        it 'returns the Excel icon for an XLSX file' do
            expect(helper.file_type_icon('file.xlsx')).to include('fa-file-excel')
            expect(helper.file_type_icon('file.xlsx')).to include('has-text-success')
        end

        it 'returns the PowerPoint icon for a PPTX file' do
            expect(helper.file_type_icon('file.pptx')).to include('fa-file-powerpoint')
            expect(helper.file_type_icon('file.pptx')).to include('has-text-warning')
        end

        it 'returns the Text icon for a TXT file' do
            expect(helper.file_type_icon('file.txt')).to include('fa-file-alt')
            expect(helper.file_type_icon('file.txt')).to include('has-text-info')
        end

        it 'returns the audio icon for a MP3 file' do
            expect(helper.file_type_icon('file.mp3')).to include('fa-file-audio')
            expect(helper.file_type_icon('file.mp3')).to include('has-text-info')
        end

        it 'returns the video icon for a MP4 file' do
            expect(helper.file_type_icon('file.mp4')).to include('fa-file-video')
            expect(helper.file_type_icon('file.mp4')).to include('has-text-info')
        end

        it 'returns the archive icon for a ZIP file' do
            expect(helper.file_type_icon('file.zip')).to include('fa-file-archive')
            expect(helper.file_type_icon('file.zip')).to include('has-text-info')
        end

        it 'returns the code icon for a HTML file' do
            expect(helper.file_type_icon('file.html')).to include('fa-file-code')
            expect(helper.file_type_icon('file.html')).to include('has-text-info')
        end

        it 'returns the image icon for a JPG file' do
            expect(helper.file_type_icon('file.jpg')).to include('fa-file-image')
            expect(helper.file_type_icon('file.jpg')).to include('has-text-info')
        end

        it 'returns the file icon for a OTHER file' do
            expect(helper.file_type_icon('file.other')).to include('fa-file')
            expect(helper.file_type_icon('file.other')).to include('has-text-warning')
        end
    end

    describe '#user_select_options' do
        it 'returns an array of users with full name and IDs' do
            user1 = FactoryBot.create(:user, first_name: 'John', last_name: 'Doe', id: 1)
            user2 = FactoryBot.create(:user, first_name: 'Smith', last_name: 'Cap', id: 2)
            allow(User).to receive(:all).and_return([user1, user2])
            expect(helper.send(:user_select_options)).to eq([[user1.full_name, user1.id], [user2.full_name, user2.id]])
        end
    end

    describe '#program_select_options' do
        it 'returns an array of programs with name and id' do
            program1 = FactoryBot.create(:program, name: 'program1', id: 1)
            program2 = FactoryBot.create(:vendor, name: 'program2', id: 2)
            allow(Program).to receive(:all).and_return([program1, program2])
            expect(helper.send(:program_select_options)).to eq([[program1.name, program1.id], [program2.name, program2.id]])
        end
    end

    describe '#entity_select_options' do
        include Devise::Test::IntegrationHelpers
        include FactoryBot::Syntax::Methods
        include Devise::Test::ControllerHelpers

        let(:entityone) { FactoryBot.create(:entity, name: 'EntityOne', id: 1) }
        let(:entitytwo) { FactoryBot.create(:entity, name: 'EntityTwo', id: 22) }
        let(:program) { FactoryBot.create(:program) }

        it 'returns an empty array when no user is logged in' do
            # before any user is signed in
            expect(helper.send(:entity_select_options)).to eq([])
        end

        it 'returns an array of entities with name and ids of current user a user of level three is logged in' do
            # after user level three is signed in
            userone = FactoryBot.create(
                :user,
                level: UserLevel::THREE,
                program:,
                entities: [entityone]
            )
            allow(Entity).to receive(:all).and_return([entityone, entitytwo])
            sign_in userone
            expect(helper.send(:entity_select_options)).to eq([[entityone.name, entityone.id]])
            sign_out userone
        end

        it 'returns an array of all entities with name and ids when a user of any level other than level 3 is logged in' do
            usertwo = FactoryBot.create(
                :user,
                level: UserLevel::ONE,
                program:,
                entities: [entityone]
            )
            # after user level one is signed in
            allow(Entity).to receive(:all).and_return([entityone, entitytwo])
            sign_in usertwo
            expect(helper.send(:entity_select_options)).to eq([[entityone.name, entityone.id], [entitytwo.name, entitytwo.id]])
        end
    end

    describe '#contract_document_filename' do
        let(:entityone) { FactoryBot.create(:entity, name: 'ABCDEFG', id: 22) }
        let(:program) { FactoryBot.create(:program, name: 'PQRSTUV') }
        let(:contractone) { FactoryBot.create(:contract, entity: entityone, program:) }

        it 'returns a filename given a contract' do
            expect(helper.send(:contract_document_filename, contractone, 'pdf')).to match(/^abcde-pqr-#{contractone.number.slice(-5, 5).downcase}-[a-zA-Z0-9]{5}pdf$/)
        end

        it 'ensures no two files of contract are same' do
            fileOneName = helper.send(:contract_document_filename, contractone, 'pdf')
            fileTwoName = helper.send(:contract_document_filename, contractone, 'pdf')
            expect(fileOneName).not_to eq(fileTwoName)
        end
    end
end

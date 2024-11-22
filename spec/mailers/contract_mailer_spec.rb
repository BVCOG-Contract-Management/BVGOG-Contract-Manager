# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContractMailer, type: :mailer do
    describe '#expiry_reminder' do
        let(:program_manager) { create(:user, program: contract.program, is_program_manager: true) }
        let(:point_of_contact) { create(:user, email: 'contact@example.com') }
        let(:contract) { create(:contract, point_of_contact:, ends_at: Time.zone.today + 10) }

        before do
            program_manager
            @mail = described_class.expiry_reminder(contract).deliver_now
        end

        it 'sends emails' do
            expect(described_class.deliveries.count).to eq(1)
        end

        it 'sends email to the correct recipients' do
            expect(@mail.to).to contain_exactly(point_of_contact.email, program_manager.email)
        end

        it 'sends email with the correct subject' do
            days_remaining = (contract.ends_at.to_datetime - Time.zone.today.to_datetime).to_i
            expect(@mail.subject).to eq("REMINDER: Contract expiring in #{days_remaining} days ")
        end

        it 'sends email with the correct template' do
            expect(@mail.html_part.decoded).to match(/This is a friendly reminder that your contract, #{contract.title}, with #{contract.vendor.name} will be expiring on #{contract.ends_at.strftime('%B %d, %Y')}/)
        end
    end

    describe '#expiration_report' do
        let(:user1) { create(:user, email: 'user1@example.com') }
        let(:user2) { create(:user, email: 'user2@example.com') }
        let(:report) { create(:report, file_name: 'report.pdf', user_id: user1.id, full_path: '/path/to/report.pdf') }
        let(:config) { create(:bvcog_config, users: [user1]) }

        before do
            allow(BvcogConfig).to receive_message_chain(:last, :users).and_return([user1])
            allow(File).to receive(:read).with(Rails.root.join('app/assets/images/bvcog-logo.png').to_s).and_return('file contents')
            allow(File).to receive(:read).with(report.full_path).and_return('file contents')
            @mail = described_class.expiration_report(user1, report).deliver_now
        end

        it 'sends emails' do
            expect(described_class.deliveries.count).to eq(1)
        end

        it 'sends emails to the correct recipients' do
            expect(@mail.to).to contain_exactly(user1.email)
        end

        it 'sends emails with the subject' do
            expect(@mail.subject).to eq("Contract Expiration Report - #{Time.zone.today.strftime('%m/%d/%Y')}")
        end

        it 'sends emails and attaches the report file' do
            expect(@mail.attachments[report.file_name].body.raw_source).to eq('file contents')
        end

        it 'sends email with the correct template' do
            expect(@mail.html_part.decoded).to match(/You have been assigned to receive a monthly report of upcoming expiring contracts for the Brazos Valley Council of Governments./)
        end
    end
end

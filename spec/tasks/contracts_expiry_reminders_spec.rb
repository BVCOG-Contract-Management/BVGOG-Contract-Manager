require 'rails_helper'
require 'factory_bot_rails'
Rails.application.load_tasks

RSpec.describe 'contracts:send_expiration_reminders' do
  contact_person = User.find_by(email: 'user@example.com')
  example_program = Program.all.sample
  example_entity = Entity.all.sample

  example_program ||= FactoryBot.create(:program)
  example_entity ||= FactoryBot.create(:entity)
  contact_person ||= FactoryBot.create(:user, email: 'user@example.com', password: 'password', first_name: 'Example',
                                              last_name: 'User')

  let!(:contracts) do
    FactoryBot.create(:vendor)
    contracts = []
    100.times do |i|
      contracts << FactoryBot.create(:contract, program: example_program,
                                                entity: example_entity,
                                                point_of_contact: contact_person,
                                                ends_at: Date.today + 1.days * i,
                                                vendor: Vendor.all.sample,
                                                id: 100 + i)
    end
    contracts
  end

  it 'sends expiry reminders for contracts that are due to expire in 10, 30, 60, and 90 days' do
    Rake::Task['contracts:send_expiration_reminders'].invoke
  end

  it 'sends expiry reminders with the correct information' do
    Rake::Task['contracts:send_expiration_reminders'].invoke
  end
end

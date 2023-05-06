require 'rails_helper'
require 'factory_bot_rails'
Rails.application.load_tasks

RSpec.describe 'contracts:send_expiration_reminders' do

  contact_person = User.find_by(email: 'user@example.com')
  example_program = Program.all.sample
  example_entity = Entity.all.sample
  unless example_program
    example_program = FactoryBot.create(:program)
  end
  unless example_entity
    example_entity = FactoryBot.create(:entity)
  end
  unless contact_person
    contact_person = FactoryBot.create(:user, email: 'user@example.com', password: 'password', first_name: 'Example', last_name: 'User', program: example_program, entities: [example_entity], level: UserLevel::THREE)
  end

  let(:contract) do                                
    10.times do |i|
      FactoryBot.create(:contract, program: Program.all.sample, point_of_contact: contact_person, ends_at: Date.today + 10.days * i)
    end
  end

  it 'sends expiry reminders for contracts that are due to expire in 10, 30, 60, and 90 days' do
    Rake::Task["contracts:send_expiration_reminders"].invoke
  end

  it 'sends expiry reminders with the correct information' do
    Rake::Task["contracts:send_expiration_reminders"].invoke
  end
end

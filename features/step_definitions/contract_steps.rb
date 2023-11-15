# frozen_string_literal: true

require 'uri'
require 'cgi'
require 'factory_bot_rails'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'support', 'paths'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'support', 'selectors'))

module WithinHelpers
    def with_scope(locator, &block)
        locator ? within(*selector_for(locator), &block) : yield
    end
end
World(WithinHelpers)

Given(/^an example program exists$/) do
    FactoryBot.create(:program, id: 1, name: 'Program 1')
    programs = Program.all.inspect
    puts 'programs:'
    puts programs
end

Then('I should see {string} element') do |element_name|
    expect(page).to have_selector(:xpath, "//strong[contains(., '#{element_name}')]")
end

When('I fill in the {string} field with {string}') do |field, filler|
    fill_in field, with: filler
end

When('I fill in the new vendor name field with {string}') do |vendor|
    fill_in 'contract_new_vendor_name', with: vendor
end

When('I fill in the contract end date field with {string}') do |date|
    fill_in 'contract_ends_at', with: date
end

When('I select {string} from the vendor dropdown') do |vendor_name|
    select vendor_name, from: 'contract[vendor_id]'
end

<<<<<<< HEAD
# When('I fill in the "vendor_id" hidden field with "new"') do
#   find('#vendor_id', visible: false).set('new')
# end

When('I fill in the {string} field with {string}') do |field_name, start_date|
    fill_in field_name, with: start_date
end

=======
>>>>>>> main
When('I fill in the vendor field with vendor value {string}') do |vendor_name|
    find('#vendor_id', visible: false).set(vendor_name)
end

When('I select {string} from the program dropdown') do |program_name|
    select program_name, from: 'contract[program_id]'
end

When('I select {string} from the entity dropdown') do |entity_name|
    select entity_name, from: 'contract[entity_id]'
end

When('I select {string} from the point of contact dropdown') do |point_of_contact|
    select point_of_contact, from: 'contract[point_of_contact_id]'
end

When('I select {string} from the end trigger dropdown') do |end_trigger|
    select end_trigger, from: 'contract[end_trigger]'
end

When('I follow \/contract_documents\/{int}"') do |int|
    visit "/contract_documents/#{int}"
end

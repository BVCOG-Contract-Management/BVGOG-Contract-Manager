# frozen_string_literal: true

require "factory_bot_rails"

Given(/^the following users exist:$/) do |table|
  table.hashes.each do |attributes|
    User.create attributes
  end
  FactoryBot.create(:user, email: "user@example.com", password: "password", first_name: "Example", last_name: "User")
end

Given(/^an example user exists$/) do
  FactoryBot.create(:user, email: "user@example.com", password: "password", first_name: "Example", last_name: "User")
end


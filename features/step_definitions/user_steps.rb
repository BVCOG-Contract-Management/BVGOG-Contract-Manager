# frozen_string_literal: true

require "factory_bot_rails"

When("I show user {int}") { |int| visit "/users/#{int}" }

Given(/^an example user exists$/) do
  FactoryBot.create(
    :user,
    email: "user@example.com",
    password: "password",
    first_name: "Example",
    last_name: "User"
  )
end

Then(/^I should see the example user in the database$/) do
  user = User.find_by(email: "user@example.com")
  expect(user).not_to be_nil
end

Then("I should see the following users in the console") do |_table|
  users = User.all.inspect
  # puts table
  puts "users: "
  puts users
end

# frozen_string_literal: true

require 'factory_bot_rails'

When('I show user {int}') { |int| visit "/users/#{int}" }

When('I visit user invites') do
    visit '/users/invitation/new'
end

When('I try to redirect this user') do
    find('div.card-footer-item:contains("Redirect this user")').click
end

When('I try to deactivate this user') do
    find('div.card-footer-item:contains("Deactivate this user")').click
end

Given('I am logged in as a level 1 user') do
    step 'I am on the sign_in page'
    FactoryBot.create(
        :user,
        email: 'level1@example.com',
        password: 'password',
        first_name: 'Level',
        last_name: 'One',
        level: UserLevel::ONE,
        program: Program.all.sample,
        entities: [Entity.first]
    )

    step 'I fill in "Email" with "level1@example.com"'
    step 'I fill in "Password" with "password"'
    step 'I press "commit"'
end

Given('I am logged in as a level 2 user') do
    step 'I am on the sign_in page'
    FactoryBot.create(
        :user,
        email: 'level2@example.com',
        password: 'password',
        first_name: 'Level',
        last_name: 'Two',
        level: UserLevel::TWO,
        program: Program.all.sample,
        entities: [Entity.first]
    )

    step 'I fill in "Email" with "level2@example.com"'
    step 'I fill in "Password" with "password"'
    step 'I press "commit"'
end

Given('I am logged in as a level 3 user') do
    step 'I am on the sign_in page'
    FactoryBot.create(
        :user,
        email: 'level3@example.com',
        password: 'password',
        first_name: 'Level',
        last_name: 'Three',
        level: UserLevel::THREE,
        program: Program.all.sample,
        entities: [Entity.first]
    )

    step 'I fill in "Email" with "level3@example.com"'
    step 'I fill in "Password" with "password"'
    step 'I press "commit"'
end

Given('I am logged in as an example user') do
    step 'I am on the sign_in page'
    step 'an example user exists'
    step 'I fill in "Email" with "user@example.com"'
    step 'I fill in "Password" with "password"'
    step 'I press "commit"'
end

Given(/^an example inactive user exists/) do
    FactoryBot.create(
        :user,
        email: 'inactive@example.com',
        password: 'password',
        first_name: 'Inactive',
        last_name: 'User',
        level: UserLevel::ONE,
        program: Program.all.sample,
        entities: [Entity.first],
        is_active: false
    )
end

Given(/^an example inactive user with a redirect user exists/) do
    FactoryBot.create(
        :user,
        email: 'inactive@example.com',
        password: 'password',
        first_name: 'Inactive',
        last_name: 'User',
        level: UserLevel::ONE,
        program: Program.all.sample,
        entities: [Entity.first],
        is_active: false,
        redirect_user: User.find_by(email: 'user@example.com')
    )
end

Given(/^an example user exists$/) do
    FactoryBot.create(
        :user,
        email: 'user@example.com',
        password: 'password',
        first_name: 'Example',
        last_name: 'User',
        level: UserLevel::ONE,
        program: Program.all.sample,
        entities: [Entity.first]
    )
end

Then(/^I should see the example user in the database$/) do
    user = User.find_by(email: 'user@example.com')
    expect(user).not_to be_nil
end

Then('I should see the following users in the console') do |_table|
    users = User.all.inspect
    # puts table
    puts 'users: '
    puts users
end

Then('deactivate example user') do
    user = User.find_by(email: 'user@example.com')
    if user.present?
        puts 'found user:'
        puts user.first_name
        if user.update(is_active: false)
            puts "User #{user.first_name} is now inactive"
        else
            puts "Failed to update user: #{user.errors.full_messages}"
        end
    else
        puts 'User not found'
    end
end

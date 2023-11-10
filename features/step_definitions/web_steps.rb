# frozen_string_literal: true

Given(/^I am on (.+)$/) do |page_name|
    visit path_to(page_name)
end

Given('I have visited the user registration page') do
    visit '/users/sign_up'
end

Given('I have visited the user invite page') do
    visit '/users/invitation/new'
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
    fill_in(field, with: value)
end

When(/^I press "([^"]*)"$/) do |button|
    click_button(button)
end

When(/^I follow "([^"]*)"$/) do |link|
    click_link(link)
end

When(/^I upload "([^"]*)" to the contract documents field$/) do |filename|
    # Find the input element by name attribute
    File.new(filename, 'w')
    # Attach the file to the input element
    page.attach_file(Rails.root.join(filename)) do
        page.find('#contract-documents-file-input').click
    end
end

When('I select {string} from the {string} select box') do |option, select_name|
    select option, from: select_name
end

When('I try to edit report {int}') do |num|
    visit "/reports/#{num}/edit"
end

When('I try to edit contract {int}') do |num|
    visit "/contracts/#{num}/edit"
end

When('I try to edit vendor {int}') do |num|
    visit "/vendors/#{num}/edit"
end

When('I try to edit user {int}') do |num|
    visit "/users/#{num}/edit"
end

When('I check the show expired contracts checkbox') do
    check('report_show_expired_contracts')
end

When('I select the Entity {int} checkbox') do |num|
    find("#user_entity_ids_#{num}").set(true)
end

When('I check Entity {int}') do |num|
    check('user[entity_ids][]', option: num.to_s)
end

Then('my url should be {string}') do |url|
    current_url = page.driver.browser.current_url
    current_path = URI.parse(current_url).path
    expect(current_path).to eq(url)
end

Then(/^I should be on (.+)$/) do |page_name|
    expected_path = path_to(page_name)
    current_url = page.driver.browser.current_url
    current_path = URI.parse(current_url).path
    expect(current_path).to eq(expected_path)
end

Then(/^I should see "([^"]*)"$/) do |text|
    if page.respond_to? :should
        page.should have_content(text)
    else
        assert page.has_content?(text)
    end
end

Then(%r{^I should see /([^/]*)/$}) do |regexp|
    regexp = Regexp.new(regexp)

    if page.respond_to? :should
        page.should have_xpath('//*', text: regexp)
    else
        assert page.has_xpath?('//*', text: regexp)
    end
end

Then(/^I should not see "([^"]*)"$/) do |text|
    if page.respond_to? :should
        page.should have_no_content(text)
    else
        assert page.has_no_content?(text)
    end
end

Then(%r{^I should not see /([^/]*)/$}) do |regexp|
    regexp = Regexp.new(regexp)

    if page.respond_to? :should
        page.should have_no_xpath('//*', text: regexp)
    else
        assert page.has_no_xpath?('//*', text: regexp)
    end
end

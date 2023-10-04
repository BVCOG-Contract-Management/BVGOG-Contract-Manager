Given('I am on the sign_in page') do
    visit '/users/sign_in'
end

Given('I am on the users page') do
    visit '/users'
end

When(/^I follow "([^"]*)"$/) do |link|
    click_link(link)
end

Then('I should be on the admin page') do
    expected_path = '/admin'
	current_url = page.driver.browser.current_url
	current_path = URI.parse(current_url).path
	expect(current_path).to eq(expected_path)
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
    fill_in(field, with: value)
end

When(/^I press "([^"]*)"$/) do |button|
    click_button(button)
end
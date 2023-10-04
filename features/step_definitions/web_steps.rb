Given(/^I am on (.+)$/) do |page_name|
	visit path_to(page_name)
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

Then(/^I should be on (.+)$/) do |page_name|
	expected_path = path_to(page_name)
	current_url = page.driver.browser.current_url
	current_path = URI.parse(current_url).path
	expect(current_path).to eq(expected_path)
end

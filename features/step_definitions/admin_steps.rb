When('I check the program {int} check box') do |int|
	checkbox = find('#bvcog_config_delete_programs_1', visible: false)
	checkbox.check
end

When('I check the entity {int} check box') do |int|
	checkbox = find('#bvcog_config_delete_entities_1', visible: false)
	checkbox.check
end

Given('I am on the users page') do
	visit '/users'
end

When('I follow "Administration"') do
	puts 'following administration'
	click_link('"Administration"')
end

Then('I should be on the admin page') do
	current_url = page.driver.browser.current_url
	current_path = URI.parse(current_url).path
	expect(current_path).to eq("/admin")
end

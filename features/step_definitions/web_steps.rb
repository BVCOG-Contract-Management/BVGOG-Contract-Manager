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

Then('my url should be {string}') do |url|
  current_url = page.driver.browser.current_url
  current_path = URI.parse(current_url).path
  expect(current_path).to eq(url)
end

Given('I am logged in') do
  step 'I am on the sign_in page'
  step 'an example user exists'
  step 'I fill in "Email" with "user@example.com"'
  step 'I fill in "Password" with "password"'
  step 'I press "Log in"'
end

Given('I have visited the user invite page') do
  visit '/users/invitation/new'
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

When('I select the Entity {int} checkbox') do |num|
  find("#user_entity_ids_#{num}").set(true)
end

When('I check Entity 1') do
  check('user[entity_ids][]', option: '1')
end

Given('bvcog_config is set up') do
  # BVCOG Config
  # Create the directories if they don't exist
  Dir.mkdir(Rails.root.join('public/contracts')) unless Dir.exist?(Rails.root.join('public/contracts'))
  Dir.mkdir(Rails.root.join('public/reports')) unless Dir.exist?(Rails.root.join('public/reports'))

  # Create the config
  BvcogConfig.create(
    id: 1,
    contracts_path: Rails.root.join('public/contracts'),
    reports_path: Rails.root.join('public/reports')
  )
end

When(/^I upload "([^"]*)" to the contract documents field$/) do |filename|
  # Find the input element by name attribute
  # input_element = find('input[id="contract-documents-file-input"]', visible: false)
  File.new(filename, 'w')
  # Attach the file to the input element
  page.attach_file(Rails.root.join(filename)) do
    page.find('#contract-documents-file-input').click
  end
  # attach_file('contract[contract_documents][]', Rails.root.join(filename), make_visible: true)
  # input_element.attach_file(filename, make_visible: true)
end

When('I click the remove button for {string}') do |_filename|
  within(find('#uploaded-contract-documents-table', wait: 2)) do # waits up to 2 seconds for the file list to appear
    find('button').click # assumes button text is 'Remove'
  end
end

Then('I save and open the page') do
  save_and_open_page
end

And('I attach a file with a random name') do
  filename = "file_#{Time.now.to_i}.txt"
  File.new(filename, 'w')
  attach_file('upload', Rails.root.join(filename))
end

# Single-line step scoper
When(/^(.*) within (.*[^:])$/) do |step, parent|
  with_scope(parent) { When step }
end

# Multi-line step scoper
When(/^(.*) within (.*[^:]):$/) do |step, parent, table_or_string|
  with_scope(parent) { When "#{step}:", table_or_string }
end

Given(/^(?:|I )am on (.+)$/) do |page_name|
  visit path_to(page_name)
end

When(/^(?:|I )go to (.+)$/) do |page_name|
  visit path_to(page_name)
end

When(/^(?:|I )press "([^"]*)"$/) do |button|
  click_button(button)
end

When(/^(?:|I )follow "([^"]*)"$/) do |link|
  click_link(link)
end

When(/^(?:|I )fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in(field, with: value)
end

When(/^(?:|I )fill in "([^"]*)" for "([^"]*)"$/) do |value, field|
  fill_in(field, with: value)
end

When(/^(?:|I )fill in the following:$/) do |fields|
  fields.rows_hash.each do |name, value|
    When %(I fill in "#{name}" with "#{value}")
  end
end

When('I select {string} from the {string} select box') do |option, select_name|
  select option, from: select_name
end

When(/^(?:|I )check "([^"]*)"$/) do |field|
  check(field)
end

When(/^(?:|I )uncheck "([^"]*)"$/) do |field|
  uncheck(field)
end

When(/^(?:|I )choose "([^"]*)"$/) do |field|
  choose(field)
end

When(/^(?:|I )attach the file "([^"]*)" to "([^"]*)"$/) do |path, field|
  attach_file(field, File.expand_path(path))
end

Then(/^(?:|I )should see "([^"]*)"$/) do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

Then(%r{^(?:|I )should see /([^/]*)/$}) do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath('//*', text: regexp)
  else
    assert page.has_xpath?('//*', text: regexp)
  end
end

Then(/^(?:|I )should not see "([^"]*)"$/) do |text|
  if page.respond_to? :should
    page.should have_no_content(text)
  else
    assert page.has_no_content?(text)
  end
end

Then(%r{^(?:|I )should not see /([^/]*)/$}) do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_no_xpath('//*', text: regexp)
  else
    assert page.has_no_xpath?('//*', text: regexp)
  end
end

Then(/^the "([^"]*)" field(?: within (.*))? should contain "([^"]*)"$/) do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = field.tag_name == 'textarea' ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value}/
    else
      assert_match(/#{value}/, field_value)
    end
  end
end

Then(/^the "([^"]*)" field(?: within (.*))? should not contain "([^"]*)"$/) do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = field.tag_name == 'textarea' ? field.text : field.value
    if field_value.respond_to? :should_not
      field_value.should_not =~ /#{value}/
    else
      assert_no_match(/#{value}/, field_value)
    end
  end
end

Then(/^the "([^"]*)" field should have the error "([^"]*)"$/) do |field, error_message|
  element = find_field(field)
  classes = element.find(:xpath, '..')[:class].split(' ')

  form_for_input = element.find(:xpath, 'ancestor::form[1]')
  using_formtastic = form_for_input[:class].include?('formtastic')
  error_class = using_formtastic ? 'error' : 'field_with_errors'

  if classes.respond_to? :should
    classes.should include(error_class)
  else
    assert classes.include?(error_class)
  end

  if page.respond_to?(:should)
    if using_formtastic
      error_paragraph = element.find(:xpath, '../*[@class="inline-errors"][1]')
      error_paragraph.should have_content(error_message)
    else
      page.should have_content("#{field.titlecase} #{error_message}")
    end
  elsif using_formtastic
    error_paragraph = element.find(:xpath, '../*[@class="inline-errors"][1]')
    assert error_paragraph.has_content?(error_message)
  else
    assert page.has_content?("#{field.titlecase} #{error_message}")
  end
end

Then(/^the "([^"]*)" field should have no error$/) do |field|
  element = find_field(field)
  classes = element.find(:xpath, '..')[:class].split(' ')
  if classes.respond_to? :should
    classes.should_not include('field_with_errors')
    classes.should_not include('error')
  else
    assert classes.exclude?('field_with_errors')
    assert classes.exclude?('error')
  end
end

Then(/^the "([^"]*)" checkbox(?: within (.*))? should be checked$/) do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_true
    else
      assert field_checked
    end
  end
end

Then(/^the "([^"]*)" checkbox(?: within (.*))? should not be checked$/) do |label, parent|
  with_scope(parent) do
    field_checked = find_field(label)['checked']
    if field_checked.respond_to? :should
      field_checked.should be_false
    else
      assert !field_checked
    end
  end
end

Then(/^(?:|I )should have the following query string:$/) do |expected_pairs|
  query = URI.parse(current_url).query
  actual_params = query ? CGI.parse(query) : {}
  expected_params = {}
  expected_pairs.rows_hash.each_pair { |k, v| expected_params[k] = v.split(',') }

  if actual_params.respond_to? :should
    actual_params.should == expected_params
  else
    assert_equal expected_params, actual_params
  end
end

Then(/^show me the page$/) do
  save_and_open_page
end

Then(/^(?:|I )should be on (.+)$/) do |page_name|
  expected_path = path_to(page_name)
  current_url = page.driver.browser.current_url
  current_path = URI.parse(current_url).path
  expect(current_path).to eq(expected_path)
end

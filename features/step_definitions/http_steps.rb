# frozen_string_literal: true

Given(/^I send a DELETE request to "(.*?)"$/) do |url|
  page.driver.delete(url)
end

Given(/^I send a PUT request to "(.*?)"$/) do |url|
  page.driver.put(url)
end

Given(/^I send a GET request to "(.*?)"$/) do |url|
  page.driver.get(url)
end

# frozen_string_literal: true

require 'net/http'

uri = URI('https://example.com/vendors/4')
params = { 'vendor_review' => { 'rating' => '3', 'description' => 'dsafdsaf' }, 'commit' => 'Submit' }
headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }

Given(/^I send a DELETE request to "(.*?)"$/) do |url|
  page.driver.delete(url)
end

Given(/^I send a PUT request to "(.*?)"$/) do |url|
  page.driver.put(url)
end

Given(/^I send a POST request to "(.*?)" with data "(.*?)"$/) do |url, data|
  data = 'a' * 2049 if data == 'oversized'
  params = { 'vendor_review' => { 'rating' => '3', 'description' => data }, 'commit' => 'Submit' }
  headers = { 'Content-Type' => 'application/x-www-form-urlencoded' }
  page.driver.post(url, params, headers)
end

Given(/^I send a GET request to "(.*?)"$/) do |url|
  page.driver.get(url)
end

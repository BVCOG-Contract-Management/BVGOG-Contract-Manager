# frozen_string_literal: true

require 'httparty'

Given('I send a GET request to {string}') do |_url|
  HTTParty.get('http://localhost:3000/reports')
end

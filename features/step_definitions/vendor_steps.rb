# frozen_string_literal: true

Given('I click on the 4th star') do
    fourth_star = find('#4')
    fourth_star.click
end

When('I get the name of Vendor {int}') do |int|
    vendor = Vendor.find(int)
    name = vendor.get_name
    puts name
end

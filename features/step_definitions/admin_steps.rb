# frozen_string_literal: true

When('I press the program {int} delete button') do |program_id|
  visit "/admin/delete_program?program_id=#{program_id}"
end

When('I press the entity {int} delete button') do |entity_id|
    visit "/admin/delete_entity?entity_id=#{entity_id}"
end

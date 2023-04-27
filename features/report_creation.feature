Feature: Add a new contract

  As a platform user (of any level)
  So that I can create an new contract for approval
  I want to add a new contract entry to the database

Background:
  Given db is set up
  Given an example user exists
  Given bvcog_config is set up


Scenario: Sucessfully create contracts report
  Given I am on the new report page
  When I fill in the "report[title]" field with "TestReport"
  And I select "30" from the "report[expiring_in_days]" select box
  And I select "Entity 1" from the "report[entity_id]" select box
  And I select "Program 1" from the "report[program_id]" select box
  And I select "Example User" from the "report[point_of_contact_id]" select box
  And I press "Create Report"
  Then I should see "Report was successfully created."

Scenario: view reports auto-redirects to new report
  Given I am on the reports page
  Then I should be on the new report page

Scenario: Edit reports auto-redirects to a new report
  Given 2 example reports exist
  When I try to edit report 1
  Then my url should be "/reports/1"

Scenario: Fail to create report
  Given I am on the new report page
  And I press "Create Report"
  Then I should see "Title can't be blank"

Scenario: Go to users report page
  Given I am on the new report page
  And I follow "Users Report"
  Then I should see "Report Arguments"

Scenario: Sucessfully create users report
  Given I am on the new report page
  And I follow "Users Report"
  And I fill in "report[title]" with "Example User Report"
  And I press "Create Report"
  Then I should see "Report was successfully created."

Scenario: Delete a report
  Given 2 example reports exist
  Given I send a DELETE request to "/reports/1"
  Then I should see "You are being redirected."

Scenario: Update a report
  Given 2 example reports exist
  Given I send a PUT request to "/reports/1"
  Then I should see "You are being redirected."

Scenario: Download a report
  Given I am on the new report page
  And I follow "Users Report"
  And I fill in "report[title]" with "Example User Report"
  And I press "Create Report"
  And I follow "Export to PDF"




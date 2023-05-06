Feature: Add a new contract

  As a platform user (of any level)
  So that I can create an new contract for approval
  I want to add a new contract entry to the database

Background:
  Given db is set up
  Given an example user exists
  Given bvcog_config is set up
  Given I am logged in as a level 3 user


Scenario: Sucessfully create level 3 contracts report
  Given I am on the new report page
  When I fill in the "report[title]" field with "TestReport"
  And I select "30" from the "report[expiring_in_days]" select box
  And I select "Program 1" from the "report[program_id]" select box
  And I select "Example User" from the "report[point_of_contact_id]" select box
  And I press "Create Report"
  Then I should see "Report was successfully created."





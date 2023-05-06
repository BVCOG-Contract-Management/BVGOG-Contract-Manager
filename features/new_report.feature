Feature: Generate Contracts Report
  As a user (level 1,2,3)
  In order to see all contracts in my program
  I want to be able to generate reports for each vendor and contract

Background:
  Given 1 example users exist

@wip
Scenario: Sucessfully Generate Reports
  Given I am on the new report page
  And I fill in the "report_title" field with "Test Report"
  And I select "60" from the "report_expiring_in_days" select box
  And I press "Create Report"
  Then I should see "Report was successfully created."

@wip
Scenario: Fail to Generate Report
  Given I am on the new report page
  And I press "Create Report"
  Then I should see "Title can't be blank"

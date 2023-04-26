Feature: Get expiry emails
  As a BVCOG user
  In order to keep contracts from expring without notice
  I want to recieve reminder emails

Background:
  Given 1 example users exist
  Given 1 example entities exist
  Given 1 example programs exist
  Given 1 example vendors exist
  Given 15 example contracts exist

Scenario: Send reminder email
  Given I am on the contracts page
  When I follow "Contract 1"
  When I follow "Send expiry reminder"
  Then I should see "Expiry reminder sucessfully sent."


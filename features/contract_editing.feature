Feature: Edit contracts

  As a platform user (of any level)
  So that I can update an existing contract
  I want to edit contracts in the database

Scenario: Edit contract
  Given 1 example users exist
  Given 1 example entities exist
  Given 1 example programs exist
  Given 1 example vendors exist
  Given 1 example contracts exist
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I press "Update Contract"
  Then I should see "Contract was successfully updated."




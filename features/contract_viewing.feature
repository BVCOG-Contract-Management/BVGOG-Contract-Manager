Feature: View a contract

  As a platform user (of any level)
  So that I can monitor contracts in my entity
  I want to be able to view all contracts in my entity


Background:
  Given 1 example users exist
  Given 1 example entities exist
  Given 1 example programs exist
  Given 1 example vendors exist
  Given 15 example contracts exist

Scenario: View contracts
  Given I am on the contracts page
  Then I should see "Contract 1"
  And I should see "Contract 2"

Scenario: Search contracts
  Given I am on the contracts page
  And I fill in "search" with "Contract 11"
  And I follow "Contract 1"
  Then I should see "Edit this contract"

Scenario: Look at paginated contracts
  Given I am on the contracts page
  And I follow "Next"
  Then I should see "Contract 11"
  And I should see "Contract 12"


Scenario: Try to go next on last page
  Given I am on the contracts page
  And I follow "Last"
  Then I should not see "Next"


Scenario: Try to go next on first page
  Given I am on the contracts page
  Then I should not see "First"


Feature: View a contract

  As a platform user (of any level)
  So that I can monitor contracts in my entity
  I want to be able to view all contracts in my entity

Scenario: View contracts
  Given I am on the contracts page
  Then I should see "Contract 1"
  And I should see "Contract 2"

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


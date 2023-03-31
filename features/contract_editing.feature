Feature: Edit contracts

  As a platform user (of any level)
  So that I can update an existing contract
  I want to edit contracts in the database

Scenario: Edit contract
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  #Why doesn't this work? And I fill in "Description" with "Updated Description"
  And I press "Update Contract"
  Then I should see "Contract was successfully updated."

@wip
Scenario: Edit a contract
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I fill in "Title" with "Updated Title"
  And I press "Update Contract"
  Then I should see "Updated Title"



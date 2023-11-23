Feature: Reviewing contracts

	As a User,
	I want to be able to reject contracts
	So that contracts with inaccurate information do not populate the database.

Background:
	Given db is set up
	Given I am logged in as a level 3 user
	Given I am on the contracts page

@error
Scenario: User submit a contract
    When I follow "Contract 1"
    And I press Set to "In Review"
    Then I should see "Contract was Submitted."
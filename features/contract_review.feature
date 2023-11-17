Feature: Reviewing contracts

	As a Gatekeeper user,
	I want to be able to reject contracts
	So that contracts with inaccurate information do not populate the database.

Background:
	Given db is set up
	Given I am logged in as a level 2 user
	Given I am on the contracts page

@error
Scenario: Gatekeeper cannot set a contract to In Review
	When I follow "Contract 1"
	Then I should see "In Progress"
	And I should not see "Set to"

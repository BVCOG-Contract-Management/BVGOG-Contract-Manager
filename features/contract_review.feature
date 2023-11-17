Feature: Reviewing contracts

	As a Gatekeeper user,
	I want to be able to reject contracts
	So that contracts with inaccurate information do not populate the database.

Background:
	Given db is set up
	Given I am logged in as a level 2 user
	Given I am on the contracts page

Scenario: Gatekeeper cannot set a contract to In Review
	When I follow "Contract 1"
	Then I should not see "In Review"

@error
Scenario: Gatekeeper approve a contract
	When I follow "Contract 2"
	When I press Set to "Approved"
	Then I should see "Contract was Approved."

@error
Scenario: Gatekeeper approve a contract
	When I follow "Contract 2"
	When I press Set to "Rejected"
	And I fill "Rejection Reason" with "test"
	And press "commit"
	Then I should see "Contract was Rejected."

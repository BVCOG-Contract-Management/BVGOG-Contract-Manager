Feature: View and Invite Users

	As a BVCOG administrator
	So that I can get help managing contracts
	I want to be able to view and invite users to the contract manager

Background:
	Given db is set up
	Given an example user exists
	Given bvcog_config is set up
	Given I am logged in as a level 1 user

Scenario: View a user
	Given I am on the users page
	Then I should see "Example"

Scenario: Get back to view users page from new user page
	Given I am on the new user invitation page
	And I follow "Back to users"
	Then I should be on the users page

Scenario: Search for a user
	Given I am on the users page
	When I fill in "search" with "Example"
	Then I should see /[0-9]/

Scenario: View a user
	Given I am on the users page
	When I follow "Example"
	Then I should see "user@example.com"

Scenario: Reach Edit User Page
	Given I am on the users page
	When I follow "Example"
	And I follow "Edit this user"
	Then I should see "Edit Example User"

Scenario: Sort users by program
	Given I am on the users page
	When I follow "Program"

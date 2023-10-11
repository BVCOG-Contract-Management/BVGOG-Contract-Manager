Feature: View and Invite Users

	As a BVCOG administrator
	So that I can get help managing contracts
	I want to be able invite users to the contract manager

Background:
	Given db is set up
	Given an example user exists


Scenario: Get to user invite page
	Given I am logged in as a level 1 user
	Given I am on the users page
	And I follow "Invite a user"
	Then I should be on the new user invitation page


Scenario: Invite a level 3 user
	Given I am logged in as a level 1 user
	When I visit user invites
	When I fill in "First name" with "Liam"
	And I fill in "Last name" with "Berney"
	And I fill in "Email" with "liamrberney3@tamu.edu"
	And I select "Three" from the "user_level" select box
	And I select "Program 1" from the "user[program_id]" select box
	And I check Entity 1
	And I press "commit"
	Then I should see "User was successfully invited."


Scenario: Invite a level 2 user
	Given I am logged in as a level 1 user
	When I visit user invites
	When I fill in "First name" with "Liam"
	And I fill in "Last name" with "Berney"
	And I fill in "Email" with "liamrberney2@tamu.edu"
	And I select "Two" from the "user_level" select box
	And I select "Program 1" from the "user[program_id]" select box
	And I check Entity 1
	And I press "commit"
	Then I should see "User was successfully invited."


Scenario: Invite a level 1 user
	Given I am logged in as a level 1 user
	When I visit user invites
	When I fill in "First name" with "Liam"
	And I fill in "Last name" with "Berney"
	And I fill in "Email" with "liamrberney1@tamu.edu"
	And I select "Two" from the "user_level" select box
	And I select "Program 1" from the "user[program_id]" select box
	And I check Entity 1
	And I press "commit"
	Then I should see "User was successfully invited."

Scenario: Re-invite a user
	Given I am logged in as a level 1 user
	When I visit user invites
	When I fill in "First name" with "Liam"
	And I fill in "Last name" with "Berney"
	And I fill in "Email" with "liamrberney1@tamu.edu"
	And I select "Two" from the "user_level" select box
	And I select "Program 1" from the "user[program_id]" select box
	And I check Entity 1
	And I press "commit"
	And I follow "Resend invitation"
	Then I should see "User was successfully re-invited."

Scenario: Invite a user as level 3
	Given I am logged in as a level 3 user
	When I visit user invites
	Then I should see "You are not authorized to invite users."

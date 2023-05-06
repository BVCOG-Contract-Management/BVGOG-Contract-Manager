Feature: Add a new contract

  As a platform user (of any level)
  So that I can get help managing contracts
  I want to be able to invite users

Background:
  Given db is set up
  Given bvcog_config is set up
  Given an example user exists

@wip
Scenario: Create a user
  Given I am logged in as a level 1 user
  Given I have visited the user registration page
  Then show me the page
  When I fill in "user[first_name]" with "TestFirst"
  When I fill in "user[last_name]" with "TestLast"
  When I fill in "user[email]" with "email@example.com"
  When I fill in "user[password]" with "password"
  When I fill in "user[password_confirmation]" with "password"
  And I press "sign_up"

Scenario: Invite a user using UI
  Given I am logged in as a level 1 user
  Given I have visited the user invite page
  When I fill in "user[first_name]" with "TestFirstName"
  When I fill in "user[last_name]" with "TestLastName"
  When I fill in "user[email]" with "FeaturedUser@example.com"
  And I select "Three" from the "user[level]" select box
  And I select "Program 1" from the "user[program_id]" select box
  And I select the Entity 1 checkbox
  And I press "commit"
  Then I should see "User was successfully invited."

Scenario: Edit a user
  Given I am logged in as a level 1 user
  Given I am on the users page
  When I follow "Example"
  And I follow "Edit this user"
  And I fill in "Email" with "user2@example.com"
  And I press "Update User"
  Then I should see "User was successfully updated."
  And I should see "user2@example.com"

Scenario: Fail to edit a user
  Given I am logged in as a level 1 user
  Given I am on the users page
  When I follow "Example"
  And I follow "Edit this user"
  And I fill in "Email" with ""
  And I press "Update User"
  Then I should see "error prohibited this user from being saved"

Scenario: Fail to edit a user as level 3
  Given I am logged in as a level 3 user
  When I try to edit user 1
  And I fill in "Email" with ""
  And I press "Update User"
  Then I should see "You are not authorized to modify users."

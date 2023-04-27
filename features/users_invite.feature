Feature: View and Invite Users

  As a BVCOG administrator
  So that I can get help managing contracts
  I want to be able invite users to the contract manager

Background:
  Given db is set up
  Given an example user exists
  Given I am logged in as a level 1 user


Scenario: Get to user invite page
  Given I am on the users page
  And I follow "Invite a user"
  Then I should be on the new user page


Scenario: Invite a user
  Given I am on the new user page
  When I fill in "First name" with "Liam"
  And I fill in "Last name" with "Berney"
  And I fill in "Email" with "liamrberney@tamu.edu"
  And I select "Three" from the "user_level" select box
  And I select "Program 1" from the "user[program_id]" select box
  And I press "Create User"
  Then I should be on the users page




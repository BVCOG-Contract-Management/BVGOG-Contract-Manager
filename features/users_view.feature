Feature: View and Invite Users

  As a BVCOG administrator
  So that I can get help managing contracts
  I want to be able to view and invite users to the contract manager

Scenario: View a user
  Given an example user exists
  Given I am on the users page
  Then I should see "Example"

Scenario: Get to user invite page
  Given I am on the users page
  And I follow "Invite user"
  Then I should be on the new user page

Scenario: Get back to view users page from new user page
  Given I am on the new user page
  And I follow "Back to users"
  Then I should be on the users page

Scenario: Search for a user
  Given an example user exists
  Given I am on the users page
  When I fill in "search" with "Example"
  Then I should see "three"

Scenario: Invite a user
  Given I am on the new user page
  When I fill in "First name" with "Liam"
  And I fill in "Last name" with "Berney"
  And I fill in "Email" with "liamrberney@tamu.edu"
  And I select "Three" from the "user_level" select box
  And I press "Create User"
  Then I should be on the users page

Scenario: View a user
  Given an example user exists
  Given I am on the users page
  When I follow "Example"
  Then I should see "user@example.com"

Scenario: Reach Edit User Page
  Given an example user exists
  Given I am on the users page
  When I follow "Example"
  And I follow "Edit this user"
  Then I should see "Edit Example User"

Scenario: Edit a user
  Given an example user exists
  Given I am on the users page
  When I follow "Example"
  And I follow "Edit this user"
  And I fill in "Email" with "user2@example.com"
  And I press "Update User"
  Then I should see "User was successfully updated."
  And I should see "user2@example.com"





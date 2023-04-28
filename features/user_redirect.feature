Feature: Add a new contract

  As a platform user (of any level)
  So that I can replace leaving users
  I want to be able to redirect users

Background:
  Given db is set up
  Given an example user exists
  Given I am logged in as a level 1 user

Scenario: Try to redirect without disabling
  Given I am on the users page
  When I show user 1
  And I try to redirect this user
  And I select "Example User" from the "user[redirect_user_id]" select box
  And I press "commit"
  Then I should see "User is active and cannot be redirected"

Scenario: Disable a user
  Given I am on the users page
  When I show user 1
  And I try to disable this user
  And I follow "Disable"
  Then I should see "User was successfully updated."

Scenario: Disable and redirect a user
  Given I am on the users page
  When I show user 1
  And I try to disable this user
  And I follow "Disable"
  And I try to redirect this user
  And I select "Example User" from the "user[redirect_user_id]" select box
  And I press "commit"
  Then I should see "User was successfully redirected"

@wip
Scenario: Destroy a user
  Given I send a DELETE request to "/users/1"
  Then I should see "You are being redirected."


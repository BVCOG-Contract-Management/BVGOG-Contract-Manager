Feature: Add a new contract

  As a platform user (of any level)
  So that I can replace leaving users
  I want to be able to redirect users

Background:
  Given 5 example users exist
  Given an example user exists
  Given I am logged in as a level 1 user

Scenario: Redirect a user
  Given I am on the users page
  When I show user 1
  And I follow "Redirect this user"
  And I press "commit"
  Then I should see "User was successfully redirected."

Scenario: Destroy a user
  Given I send a DELETE request to "/users/1"
  Then I should see "You are being redirected."


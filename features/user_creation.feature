Feature: Add a new contract

  As a platform user (of any level)
  So that I can get help managing contracts
  I want to be able to invite users


#Run application controller, basically

Scenario: Create a user
  Given an example user exists
  Then I should see the example user in the database

Scenario: Create a user using UI
  Given I am on the users page
  When I follow "Invite user"
  When I fill in "user[first_name]" with "TestFirstName"
  When I fill in "user[last_name]" with "TestLastName"
  When I fill in "user[email]" with "FeaturedUser@example.com"
  When I fill in "user[email]" with "FeaturedUser@example.com"
  And I select "Three" from the "user[level]" select box
  And I press "Create User"


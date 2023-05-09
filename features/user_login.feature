Feature: log in to website

  As a BVCOG user
  So that I can securely access contracts
  I want to be able to securely log in and out to the contract manager


Background:
  Given 1 example programs exist
  Given 1 example entities exist

Scenario: fail login
    Given I am on the sign_in page
    When I fill in "Email" with "user@example.com"
    And I fill in "Password" with "incorrect_password"
    And I press "commit"
    Then I should see "Invalid Email or password."

Scenario: User logs in successfully
    Given an example user exists
    Given I am on the sign_in page
    When I fill in "Email" with "user@example.com"
    And I fill in "Password" with "password"
    And I press "commit"
    Then I should see "Signed in successfully"

Scenario: User logs out
    Given an example user exists
    Given I am on the sign_in page
    When I fill in "Email" with "user@example.com"
    And I fill in "Password" with "password"
    And I press "commit"
    And I follow "Sign Out"
    Then I should be on the sign_in page

Scenario: Level 3 log in
    Given I am logged in as a level 1 user
    And I am on the home page
    Then I should see "Welcome"

@wip
Scenario: Try to log in as inactive user
    Given an example user exists
    Then deactivate example user
    Given I am on the sign_in page
    When I fill in "Email" with "user@example.com"
    And I fill in "Password" with "password"
    And I press "commit"
    Then I should see "Your account is not currently active."


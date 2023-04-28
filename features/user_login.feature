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
    And I press "Log in"
    Then I should see "Invalid Email or password."

Scenario: User logs in successfully
    Given an example user exists
    Given I am on the sign_in page
    When I fill in "Email" with "user@example.com"
    And I fill in "Password" with "password"
    And I press "Log in"
    Then I should see "Signed in successfully"


#Scenario: User logs out
#    Given I am on the home page
#    And I follow "Sign Out"
#    Then I should be on the sign_in page

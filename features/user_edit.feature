Feature: Edit a user

    As a BVCOG administrator
    I want to be able to edit users
    So that I can update users to different programs or entities

Background:
	Given db is set up
	Given bvcog_config is set up
    Given an example user exists

Scenario: Try to edit a user while not an administrator
    Given I am logged in as a level 2 user
    And I am on the users page
    And I visit the edit page for user 1
    Then I should see "You do not have permission to access this page."

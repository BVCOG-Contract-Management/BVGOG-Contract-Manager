Feature: Home Page Contracts Display

	Background:
		Given db is set up

	Scenario: Level 3 user views the home page
		Given I am logged in as a level 3 user
		And I am on the home page
		Then all contracts displayed should be in progress
		And all amendments and renewals displayed should be in progress

	Scenario: Other level user views the home page
		Given I am logged in as a level 2 user
		And I am on the home page
		Then all contracts displayed should be in review
		And all amendments and renewals displayed should be in review

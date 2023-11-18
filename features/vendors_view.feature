Feature: View and Invite Users

	As a BVCOG administrator
	So that I can choose the best vendor for a contract
	I want to be able to view vendors with a review system

Background:
	Given db is set up
	Given I am logged in as a level 1 user
	Given bvcog_config is set up

Scenario: Vendor Rating
	Given I am on the vendors page
	Then I should see "Vendor 1"

Scenario: View a vendor
	Given I am on the vendors page
	And I follow "Vendor 1"
	Then I should see "Review this vendor"

Scenario: Sort vendors by reviews
	Given I am on the vendors page
	When I follow "Reviews"

Scenario: Sort vendors by rating
	Given I am on the vendors page
	When I follow "Average Rating"

@error
Scenario: Search vendor
	Given I am on the vendors page
	And I fill in "search" with "Vendor"
	Then I should see "Vendor"

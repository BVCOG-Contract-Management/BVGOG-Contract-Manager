Feature: Edit contracts

	As a platform user (of any level)
	So that I can update an existing contract
	I want to edit contracts in the database


Background:
	Given 1 example entities exist
	Given 1 example programs exist
	Given an example user exists
	Given 1 example vendors exist
	Given 1 example contracts exist
	Given I am logged in as a level 1 user
	Given I am on the contracts page

Scenario: Edit contract
	When I follow "Contract 1"
	And I follow "Edit this contract"
	And I press "Update Contract"
	Then I should see "Contract was successfully updated."


Scenario: Fail to edit contract
	When I follow "Contract 1"
	And I follow "Edit this contract"
	And I fill in "Title" with ""
	And I press "Update Contract"
	Then I should see "1 error prohibited this contract from being saved:"

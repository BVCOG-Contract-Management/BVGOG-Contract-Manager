Feature: Amend contracts

	As a level 3 user (of any level)
	So that I can update an existing contract
	I want to Amend contracts in the database


Background:
	Given 1 example entities exist
	Given 1 example programs exist
	Given an example user exists
	Given 1 example vendors exist
	Given 1 example contracts exist
	Given I am logged in as a level 3 user
	Given I am on the amend page

Scenario: Amend contract successfully
    And I fill in "Contract ID" with "1234"
    And I press "Update Contract" 
	Then I should see "Amendment request for Contract 1 submitted successfully and is pending approval"


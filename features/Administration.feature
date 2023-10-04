Feature: View and Invite Users

	As a BVCOG administrator
	So that I can manage the application
	I want to be able to access the adminstration page

Background:
	Given db is set up
	And an example user exists
	And bvcog_config is set up
	And I am logged in as a level 1 user

Scenario: Get to admin page
	Given I am on the users page
	When I follow "Administration"
	Then I should be on the admin page

Scenario: Update contract document storage
	Given I am on the admin page
	And I fill in "bvcog_config[contracts_path]" with "/mnt/c/MrPineapple/TAMU/BVGOG-Contract-Manager/public/contracts"
	And I press "commit"
	Then I should see "Configuration was successfully updated."

Scenario: Fail to update contract document storage
	Given I am on the admin page
	And I fill in "bvcog_config[contracts_path]" with "/mnt/c/MrPineapple/TAMU/BVGOG-Contract-Manager/public/does_not_exist"
	And I press "commit"
	Then I should see "Contracts path is invalid."

Scenario: Update contract reports storage
	Given I am on the admin page
	And I fill in "bvcog_config[reports_path]" with "/mnt/c/MrPineapple/cuTAMU/BVGOG-Contract-Manager/public/reports"
	And I press "commit"
	Then I should see "Configuration was successfully updated."

Scenario: Fail to update contract reports storage
	Given I am on the admin page
	And I fill in "bvcog_config[reports_path]" with "/mnt/c/MrPineapple/TAMU/BVGOG-Contract-Manager/public/does_not_exist"
	And I press "commit"
	Then I should see "Reports path is invalid."

Scenario: Add a program
	Given I am on the admin page
	When I fill in "Program Name" with "new program"
	And I press "add_program"
	And I press "commit"
	Then I should see "Configuration was successfully updated."

Scenario: Add an entity
	Given I am on the admin page
	When I fill in "Entity Name" with "new entity"
	And I press "add_entity"
	And I press "commit"
	Then I should see "Configuration was successfully updated."

Scenario: Delete a program
	Given I am on the admin page
	When I check the program 1 check box
	And I press "commit"
	Then I should see "Attempted to delete program with associated users program: Program 1"

Scenario: Delete an entity
	Given I am on the admin page
	When I check the entity 1 check box
	And I press "commit"
	Then I should see "Attempted to delete entity with associated users entity: Entity 1"


@wip
Scenario: Try to get to admin page as a level 3 user
	Given I am logged in as a level 3 user
	Given I am on the users page
	And I follow "Administration"
	Then I should see "You do not have permission to access this page"

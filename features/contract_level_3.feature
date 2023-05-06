Feature: Only allow level >3 users to create contracts

  As a BVCOG admin
  So that I can keep contract data secure
  I want to keep level 3 users from creating or modifying contracts

Background:
  Given db is set up
  Given an example user exists
  Given bvcog_config is set up
  Given I am logged in as a level 3 user

Scenario: Fail to create contract as level 3
  Given I am on the new contract page
  When I fill in "Title" with "TestContract"
  And I select "Contract" from the "Contract type" select box
  And I select "Limited Term" from the "End trigger" select box
  And I select "hour" from the "Amount duration" select box
  And I select "day" from the "Initial term duration" select box

  And I fill in "Number" with "23"
  And I fill in "Amount dollar" with "100"
  And I fill in "Initial term amount" with "100"

  And I fill in the "contract_starts_at" field with "2023-03-30"
  And I fill in the "contract_ends_at" field with "2025-03-30"

  And I select "New Vendor" from the vendor dropdown
  And I fill in the "contract_new_vendor_name" field with "Test Vendor"
  And I select "Program 1" from the program dropdown
  #And I select "Entity 1" from the entity dropdown
  And I select "Example User" from the point of contact dropdown
  And I press "Create Contract"
  Then I should see "The current user does not have permission to read the given resource"

Scenario: Fail to edit contract as level 3
  When I try to edit contract 1
  And I press "commit"
  Then I should see "The current user does not have permission to read the given resource"

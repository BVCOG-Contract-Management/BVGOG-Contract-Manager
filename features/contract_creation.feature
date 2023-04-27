Feature: Add a new contract

  As a platform user (of any level)
  So that I can create an new contract for approval
  I want to add a new contract entry to the database

Background:
  Given db is set up
  Given an example user exists
  Given I am logged in as a level 1 user

Scenario: Fail to create contract
  Given I am on the new contract page
  And I press "Create Contract"
  Then I should see "Title can't be blank"
  And I should see "Entity can't be blank"
  And I should see "Program can't be blank"
  And I should see "Point of contact can't be blank"
  And I should see "Vendor can't be blank"
  And I should see "Starts at can't be blank"
  And I should see "Ends at can't be blank"
  And I should see "Amount dollar is not a number"
  And I should see "Initial term amount is not a number"
  And I should see "Contract type can't be blank"
  And I should see "Contract type is not included in the list"
  And I should see "Amount duration is not included in the list"
  And I should see "Initial term duration is not included in the list"
  And I should see "End trigger is not included in the list"
  And I should see "Entity must exist"
  And I should see "Program must exist"
  And I should see "Point of contact must exist"
  And I should see "Vendor must exist"


Scenario: Sucessfully create contract
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
  And I select "Entity 1" from the entity dropdown
  And I select "Example User" from the point of contact dropdown
  And I press "Create Contract"
  Then I should see "Contract was successfully created."

Scenario: Delete a contract
  Given I send a DELETE request to "/contracts/6"
  Then I should see "You are being redirected."


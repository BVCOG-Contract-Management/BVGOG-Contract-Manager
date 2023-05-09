Feature: View and Invite Users

  As a BVCOG administrator
  So that I can choose the best vendor for a contract
  I want to be able to add vendors

Background:
  Given 1 example entities exist
  Given 1 example programs exist
  Given 1 example vendors exist
  Given 1 example users exist
  Given 1 example contracts exist
  Given bvcog_config is set up
  Given I am logged in as a level 1 user

Scenario: Add vendor
  Given I am on the new vendor page
  And I fill in "vendor[name]" with "Example Vendor"
  And I press "Create Vendor"
  Then I should see "Vendor was successfully created."

Scenario: Fail to add vendor
  Given I am on the new vendor page
  And I press "Create Vendor"
  Then I should see "Name can't be blank"

Scenario: Fail to edit a vendor
  When I try to edit vendor 1
  And I fill in "vendor[name]" with "1"
  And I press "commit"
  Then I should see "Vendor was successfully updated."

Scenario: Edit a vendor
  When I try to edit vendor 1
  And I press "commit"
  Then I should see "Vendor was successfully updated."

Scenario: Back to vendors
  Given I am on the new vendor page
  And I follow "Back to vendors"
  Then I should see "View Vendors"


Scenario: Get Name
  When I get the name of Vendor 1






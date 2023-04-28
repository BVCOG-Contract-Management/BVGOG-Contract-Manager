Feature: View and Invite Users

  As a BVCOG administrator
  So that I can choose the best vendor for a contract
  I want to be able to add vendors

Background:
  Given 5 example vendors exist
  Given bvcog_config is set up

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

Scenario: Destroy a vendor
  When I send a DELETE request to "/vendors/1"
  Then I should see "You are being redirected."






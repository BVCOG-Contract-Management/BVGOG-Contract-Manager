Feature: View and Invite Users

  As a BVCOG administrator
  So that I can choose the best vendor for a contract
  I want to be able to view vendors with a review system

Background:
  Given db is set up
  Given I am logged in as a level 1 user
  Given bvcog_config is set up

Scenario: View vendors
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

Scenario: Review a vendor
  Given I am on the vendors page
  And I follow "Vendor 1"
  And I follow "Review this vendor"
  And I fill in the "vendor_review[description]" field with "Test Description"
  And I click on the 4th star
  And I press "commit"
  Then I should see "Reviews of vendor 1"
  And I should see "Test Description"





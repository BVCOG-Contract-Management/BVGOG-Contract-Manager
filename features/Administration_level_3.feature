Feature: View and Invite Users

  As a BVCOG administrator
  So that I can keep the application secure
  I only want level 1 users to access the admin panel

Background:
  Given db is set up
  Given an example user exists
  Given bvcog_config is set up
  Given I am logged in as a level 3 user

Scenario: Get to admin page as level 3
  Given I am on the admin page
  Then I should see "You do not have permission to access this page."

Scenario: Update admin as level 3
  Given I am on the admin page
  And I send a PUT request to "/admin"
  Then I should see "You are being redirected."






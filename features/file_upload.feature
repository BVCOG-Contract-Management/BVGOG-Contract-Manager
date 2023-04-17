Feature: Upload Files

  As a platform user (of any level)
  So that I can upload information about contracts
  I want be able to upload files to the db

Background:
  Given 1 example entities exist
  Given 1 example programs exist
  Given 1 example vendors exist
  Given 1 example users exist
  Given 1 example contracts exist

Scenario: Upload a file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.txt" to the contract documents field
  And I press "commit"




Feature: Upload Files

  As a platform user (of any level)
  So that I can upload information about contracts
  I want be able to upload files to the db

@wip
Scenario: Upload a file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.txt" to the contract documents field
  And I press "Remove"



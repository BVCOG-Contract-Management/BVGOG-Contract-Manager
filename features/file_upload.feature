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
  Given bvcog_config is set up

Scenario: Upload a txt file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.txt" to the contract documents field
  And I press "commit"

Scenario: Upload a pdf file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.pdf" to the contract documents field
  And I press "commit"

Scenario: Upload a doc file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.doc" to the contract documents field
  And I press "commit"

Scenario: Upload a xlsx file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.xlsx" to the contract documents field
  And I press "commit"

Scenario: Upload a pptx file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.pptx" to the contract documents field
  And I press "commit"

Scenario: Upload a jpg file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.jpg" to the contract documents field
  And I press "commit"


Scenario: Upload a zip file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.zip" to the contract documents field
  And I press "commit"

Scenario: Upload a mp3 file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.mp3" to the contract documents field
  And I press "commit"

Scenario: Upload a mp4 file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.mp4" to the contract documents field
  And I press "commit"

Scenario: Upload a html file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.html" to the contract documents field
  And I press "commit"

Scenario: Upload a other file
  Given I am on the contracts page
  When I follow "Contract 1"
  And I follow "Edit this contract"
  And I upload "temp.other" to the contract documents field
  And I press "commit"

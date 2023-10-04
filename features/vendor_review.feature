# Feature: View and Invite Users

#   As a BVCOG administrator
#   So that I can choose the best vendor for a contract
#   I want to be able to review vendors

# Background:
#   Given db is set up
#   Given I am logged in as a level 1 user
#   Given bvcog_config is set up

# Scenario: Go to vendors review page
#   Given I am on the vendors page
#   And I follow "Vendor 1"
#   And I follow "Review this vendor"
#   Then I should see "Review Vendor 1"

# Scenario: Sucessfully review a vendor
#   When I send a POST request to "/vendors/4/vendor_reviews" with data "abcdefg"
#   Then I should see "You are being redirected."

# Scenario: Review a vendor with blank description
#   When I send a POST request to "/vendors/4/vendor_reviews" with data ""
#   Then I should see "You are being redirected."

# Scenario: Review a vendor with an oversized description
#   When I send a POST request to "/vendors/4/vendor_reviews" with data "oversized"
#   Then I should see "You are being redirected."

# Scenario: Try to review a vendor already reviewed
#   When I send a POST request to "/vendors/4/vendor_reviews" with data "abcdefg"
#   When I send a POST request to "/vendors/4/vendor_reviews" with data "abcdefg"
#   Then I should see "You are being redirected."

Feature: assign member to resource

Scenario: new resource
  Given on cobot I have a space "co-up"
    And the space "co-up" has a member "Joe Doe" on cobot
    And I am logged in
    And the space "co-up" has a category "Small Office" with 3 resources
  When I assign "Joe Doe" to "Small Office 2"
  Then I should see that "Joe Doe" is assigned to "Small Office 2"
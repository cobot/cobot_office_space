Feature: assign member to resource

Scenario: assign member to new resource
  Given on cobot I have a space "co-up"
    And the space "co-up" has a member "Joe Doe" on cobot
    And I am logged in
    And the space "co-up" has a category "Small Office" with 3 resources
  When I assign "Joe Doe" to "Small Office 2"
  Then I should see that "Joe Doe" is assigned to "Small Office 2"

Scenario: delete resource
  Given on cobot I have a space "co-up"
  	And I am logged in
    And the space "co-up" has a category "Small Office" with 3 resources
  When I remove the resource "Small Office 2"
  Then I should see that the category "Small Office" has no resource "Small Office 2"
  
 Scenario: add resources
   Given on cobot I have a space "co-up"
  	And I am logged in
    And the space "co-up" has a category "Small Office"
  When I add the resource "Small Office 1"
  Then I should see a category "Small Office" with the resources "Small Office 1"	
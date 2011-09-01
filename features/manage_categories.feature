Feature: Manage Categories

Scenario: add category
  Given on cobot I have a space "co-up"
    And I am logged in
  When I add the category "Small Office" with 3 resources
  Then I should see a category "Small Office" with the resources "Small Office 01/Small Office 02/Small Office 03"

 Scenario: remove category
  Given on cobot I have a space "co-up"
    And I am logged in
    And the space "co-up" has a category "Big Office"
   When I remove the category "Big Office"
   Then I should see no category "Big Office"
 	
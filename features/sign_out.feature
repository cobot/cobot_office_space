Feature: sign out

Scenario: signed in
  Given I am logged in
  When I follow "Sign out"
  Then I should be signed out
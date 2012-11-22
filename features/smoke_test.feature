Feature: Smoke tests providing a cursory indication of the health of Shrink

  Scenario: Homepage verification
    When I visit the home page
    Then the page should be shown without error

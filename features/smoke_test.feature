Feature: Smoke tests providing a cursory indication of the health of Shrink

  Scenario: Homepage verification
    When I navigate to the homepage
    Then the page should be shown without error

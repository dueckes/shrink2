Feature: Smoke tests providing a cursory indication of the health of Shrink

  Scenario: Home page verification
    When I visit the home page
    Then the page should be shown without error

  Scenario: Sign-in verification
    Given I visit the sign-in page
    When I sign-in as an administrator
    Then the projects page should be shown

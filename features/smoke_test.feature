Feature: Smoke tests providing a cursory indication of the health of Shrink
  In order to ascertain the health of the application
  As someone with a stake in the application
  I would like to smoke test the key features of the application

  Scenario: Home page verification
    When a user visits the home page
    Then the page should be shown without error

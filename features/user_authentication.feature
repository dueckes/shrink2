Feature: Authentication of users
  In order to facilitate user authorization levels
  And to audit the actions of users
  As a requirements maintainer
  I would like users to authenticate in order to access Shrink

  Scenario: Sign-in administrator
    Given a user visits the sign-in page
    When the user signs-in as an administrator
    Then the projects page should be shown

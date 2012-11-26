Feature: Project editor
  In order to maintain features for multiple projects
  As a requirements maintainer
  I would like to maintain a set of projects
  And view summary dashboard for each project

  Scenario: Create project
    Given a signed-in user
    And the user is on the projects page
    When the user creates a project
    Then a link to the project is shown in the project list
    And the details of the project are shown

  Scenario: View project
    Given a signed-in user
    And a project has been created
    When the user visits the projects page
    And the user views the project
    Then the details of the project are shown

Feature: Step Having A Table

  Scenario: A step has a table
    Given this step is followed by a table:
    | key 1     | key 2     | key 3     |
    | value 1.1 | value 2.1 | value 3.1 |
    | value 1.2 | value 2.2 | value 3.2 |
    | value 1.3 | value 2.3 | value 3.3 |
    Then Shrink should successfully import the table

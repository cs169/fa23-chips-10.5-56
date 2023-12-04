Feature: Representative Profile Page

  As a user
  I want to view detailed information about representatives
  So that I can learn more about their background, contact details, and political affiliation

  Background:
    Given the following representatives exist:
      | name             | title  | party    | photo                      | address1       | city        | state | zip   |
      | Henry C. Levy         | Alameda County Treasurer-Tax Collector | Nonpartisan | https://example.com/johndoe.jpg | 1221 Oak Street    | Oakland    | CA    | 94612 |
      | Jane Smith       | Alameda County Auditor-Controller-Clerk-Recorder | Nonpartisan | https://example.com/janesmith.jpg | 	1221 Oak Street | Oakland  | CA    | 94612 |
      # Add more representatives as needed

  Scenario: View a representative's profile
    Given I am on the Alameda County page
    When I follow "Details" for "Henry C. Levy"
    Then I should see "Henry C. Levy"'s profile details


Feature: Change travel of several travel records at once

  Background: Prepare the application
    Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
      And table "Travels" has 4133 records
      And we open value help for filter field "Travel Status"
      And we select one suggestion in value help dialog for field "Travel Status" equal to "Open"
      And we close value help for filter field "Travel Status"
      And we apply the search filter
      And table "Travels" has 2469 records

  Scenario: Filter open travel records, accept top two
    When we select row 1 in table "Travels"
      And we select row 2 in table "Travels"
      And we press button "Accept Travel"
      And we apply the search filter
    Then we expect table "Travels" to have 2467 records in total

  Scenario: Filter open travel records, reject top two
    When we select row 1 in table "Travels"
      And we select row 2 in table "Travels"
      And we press button "Reject Travel"
      And we apply the search filter
    Then we expect table "Travels" to have 2467 records in total

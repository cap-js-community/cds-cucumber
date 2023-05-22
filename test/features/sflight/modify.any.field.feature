Feature: Modify any field

  Background: Prepare the application
    Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
      And table "Travels" has 4133 records

  Scenario: Travel status
    When we modify field "Travel Status" to "Open"
      And we apply the search filter
    Then we expect table "Travels" to have 2469 records in total

  Scenario: Editing status
    When we modify field "Editing Status" to "All"
      And we apply the search filter
    Then we expect table "Travels" to have 4133 records in total

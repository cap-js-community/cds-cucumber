Feature: Change draft editing state

  Scenario: Filter open travel records, accept top two
    Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
      And table "Travels" has 4133 records
    When we select rows in table "Travels" having "Customer" equal to "Benz (000115)"
      And we delete selected rows in table "Travels"
      And we confirm the deletion
    Then we expect table "Travels" to have 4132 records in total

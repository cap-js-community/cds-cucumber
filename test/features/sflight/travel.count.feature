Feature: Check total travel record count

  Scenario: Check total count of records in table Travels
    Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
    Then we expect table "Travels" to have 4133 records in total

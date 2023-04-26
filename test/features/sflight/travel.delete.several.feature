Feature: Select travel records and delete them

  Background: Start service and open travel processor
    Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
      And table "Travels" has 4133 records

  Scenario: Select travel record and delete it
    When we select row 1 in table "Travels"
      And we delete selected rows in table "Travels"
      And we confirm the deletion
    Then we expect table "Travels" to have 4132 records in total

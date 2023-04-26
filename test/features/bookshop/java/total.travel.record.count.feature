@todo
Feature: Check total travel record count

  Scenario: Check total count of records in table Travel
    Given we have started the java application
      And we have opened the url "/travel_processor/webapp/index.html" with user "admin" and password "admin"
    Then we expect table "Travels" to have 4133 records in total

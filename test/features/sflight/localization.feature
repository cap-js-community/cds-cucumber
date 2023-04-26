Feature: Change language

  Background: Prepare the application
    Given we have started the application
      And we have set language to "DE"
      And we have opened the url "/travel_processor/webapp/index.html"

  Scenario: Find table Reisen
      Then table "Reisen" has 4133 records

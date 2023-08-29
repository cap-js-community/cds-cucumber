Feature: List all books

  Scenario: List all books
    Given we have started the application
      And we have connected to service TravelService as user "alice" with password ""
      And we have opened the url "/travel_processor/webapp/index.html"
    When we read entity Travel by selecting TravelUUID
    Then we expect the result to contain the following record
      """
      {"TravelUUID":"19737221A8E4645C17002DF03754AB66","IsActiveEntity":true}
      """
      And we expect table "Travels" to have 4133 records in total

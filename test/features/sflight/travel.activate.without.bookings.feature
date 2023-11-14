Feature: Activate travel draft without bookings

  Background: Prepare the application
    Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
      And table "Travels" has 4133 records
      And we create draft
      And we open value help for object field "Agency"
      And we select one row in value help dialog having field "Agency Name" equal to "Fly High"
      And we open value help for object field "Customer"
      And we select one row in value help dialog having field "Customer" equal to "000001"
      And we change field "Booking Fee" to "10"
      And we change field "Starting Date" to "Feb 21, 2033"
      And we change field "End Date" to "Feb 22, 2033"
      And we change field "Description" to "new travel"

  Scenario: Activate open travel draft without bookings
    Then we save the draft
      And we go back
      And we filter by "Customer" equal to "000001"
      And we apply the search filter
      And table "Travels" has 6 records
      And we expect table "Travels" to contain record
      """
      {
        "Agency": "Fly High (070002)",
        "Booking Fee": {
          "value": "10"
        },
        "Customer": "Buchholm (000001)",
        "Total Price": {
          "value": "10"
        },
        "Travel": {
          "text": "new travel"
        },
        "Travel Status": "Open"
      }
      """

  Scenario: Activate accepted travel draft without bookings
    When we press button "Accept Travel"
    Then we save the draft
      And we go back
      And we filter by "Customer" equal to "000001"
      And we apply the search filter
      And table "Travels" has 6 records
      And we expect table "Travels" to contain record
      """
      {
        "Agency": "Fly High (070002)",
        "Booking Fee": {
          "value": "10"
        },
        "Customer": "Buchholm (000001)",
        "Total Price": {
          "value": "10"
        },
        "Travel": {
          "text": "new travel"
        },
        "Travel Status": "Accepted"
      }
      """

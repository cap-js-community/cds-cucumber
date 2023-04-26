Feature: Create draft, save and change status

  Background: Start service and open travel processor
    Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
      And table "Travels" has 4133 records
    When we create draft
      And we open value help for object field "Agency"
      And we select one row in value help dialog having field "Agency Name" equal to "Fly High"
      And we open value help for object field "Customer"
      And we select one row in value help dialog having field "Customer" equal to "000001"
      And we change field "Booking Fee" to "10"
      And we change field "Starting Date" to "Feb 21, 2033"
      And we change field "End Date" to "Feb 22, 2033"
      And we change field "Description" to "new travel"

  Scenario: Create, change, keep status open and save a travel draft
    When we save the draft
      And we navigate to url "/travel_processor/webapp/index.html"
    Then we expect table "Travels" to contain record
      """
      { "Travel": { "text":"new travel" }, "Travel Status": "Open" }
      """
      And we expect table "Travels" to have 4134 records in total

  Scenario: Create, change, accept and save a travel draft
    When we save the draft
      And we perform object action "Accept Travel"
      And we navigate to url "/travel_processor/webapp/index.html"
    Then we expect table "Travels" to contain record
      """
      { "Travel": { "text":"new travel" }, "Travel Status": "Accepted" }
      """
      And we expect table "Travels" to have 4134 records in total

  Scenario: Create, change, reject and save a travel draft
    When we save the draft
      And we perform object action "Reject Travel"
      And we navigate to url "/travel_processor/webapp/index.html"
    Then we expect table "Travels" to contain record
      """
      { "Travel": { "text":"new travel" }, "Travel Status": "Canceled" }
      """
      And we expect table "Travels" to have 4134 records in total

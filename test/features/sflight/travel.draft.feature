Feature: Create draft

  Background: Start service and open travel processor
   Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
      And table "Travels" has 4133 records

  Scenario: Create, change and save a travel draft
    When we create draft
      And we open value help for object field "Agency"
      And we select one row in value help dialog having field "Agency Name" equal to "Fly High"
      And we open value help for object field "Customer"
      And we select one row in value help dialog having field "Customer" equal to "000001"
      And we change field "Booking Fee" to "10"
      And we change field "Starting Date" to "Feb 21, 2033"
      And we change field "End Date" to "Feb 22, 2033"
      And we change field "Description" to "new travel"
      And we save the draft
      And we go back
    Then we expect table "Travels" to contain record
      """
      { "Travel": { "text":"new travel" } }
      """
      And we expect table "Travels" to have 4134 records in total

  Scenario: Create, change field, add new booking and save a travel draft
    When we create draft
      And we open value help for object field "Agency"
      And we select one row in value help dialog having field "Agency Name" equal to "Fly High"
      And we open value help for object field "Customer"
      And we select one row in value help dialog having field "Customer" equal to "000001"
      And we change field "Booking Fee" to "10"
      And we change field "Starting Date" to "Feb 21, 2033"
      And we change field "End Date" to "Feb 22, 2033"
      And we change field "Description" to "new travel"
      And we create new item for table in section "Bookings"
      And we change the field "Customer" in the last row of table in section "Bookings" to "test"
      And we change the field "Airline" in the last row of table in section "Bookings" to "TST"
      And we change the field "Flight Number" in the last row of table in section "Bookings" to "123"
      And we change the field "Flight Date" in the last row of table in section "Bookings" to "2033-01-02"
      And we change the field "Flight Price" in the last row of table in section "Bookings" to "99"
      And we save the draft
      And we go back
    Then we expect table "Travels" to contain record
      """
      { "Travel": { "text":"new travel" } }
      """
      And we expect table "Travels" to have 4134 records in total

  Scenario: Create, change field, new booking, open booking, edit booking fields, go back and save a travel draft
    When we create draft
      And we open value help for object field "Agency"
      And we select one row in value help dialog having field "Agency Name" equal to "Fly High"
      And we open value help for object field "Customer"
      And we select one row in value help dialog having field "Customer" equal to "000001"
      And we change field "Booking Fee" to "10"
      And we change field "Starting Date" to "Feb 21, 2033"
      And we change field "End Date" to "Feb 22, 2033"
      And we change field "Description" to "new travel"
      And we create new item for table in section "Bookings"
      # java - the id is "New Object", it is geven later during activation
      # And we tap on text "1"
      And we tap on row 0 in table "Bookings"
      And we open value help for object field "Customer"
      And we select one row in value help dialog having field "Customer" equal to "000001"
      And we open value help for object field "Airline"
      And we select one row in value help dialog having field "Name" equal to "European Airlines"
      And we open value help for object field "Flight Number"
      And we select first row in value help dialog having field "Flight Number" equal to "0400"
      And we apply the changes
      And we save the draft
    Then we expect table "Bookings" to have 1 records in total

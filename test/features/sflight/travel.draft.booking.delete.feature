Feature: Create draft

  Background: Start service and open travel processor
   Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
      And table "Travels" has 4133 records

  Scenario: Create travel, create booking and delete it
    When we create draft
      And we create new item for table "Bookings"
      And we select row 1 in table "Bookings"
      And we delete selected rows in table "Bookings"
      And we confirm the deletion

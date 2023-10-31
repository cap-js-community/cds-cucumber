Feature: Test has ValueHelp step

  Background: Start service and open travel processor
   Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"

  Scenario: Check ValueHelp for all fields
    When we create draft
      And field "Description" has no value help
      And field "Booking Fee" has value help
      And field "Currency" has value help
      And field "Starting Date" has no value help
      And field "End Date" has no value help
      And field "Agency" has value help
      And field "Customer" has value help
      And we open value help for field "Currency"
      And we press button "Show Filters"
      And field "Name" has value help
      And field "Description" has value help
      And field "Currency Code" has value help
      And field "Currency Symbol" has value help

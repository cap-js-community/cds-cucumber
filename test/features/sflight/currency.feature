Feature: Currency selection

  Background: Prepare the application
    Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
    When we create draft

  @skip:java
  Scenario: Select currency - node
    When we modify field "Booking Fee" to "10"
      And we open value help for object field "Currency"
      And we select one row in value help dialog having field "Description" equal to "euro"

  @skip:node
  Scenario: Select currency - java
    When we modify field "Booking Fee" to "10"
      And we open value help for object field "Currency"
      And we select one row in value help dialog having field "Description" equal to "European Euro"

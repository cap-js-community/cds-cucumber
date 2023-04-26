Feature: Currency selection

  Background: Prepare the application
    Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
    When we create draft

  @skip:java
  Scenario: Select currency for booking fee - node
    When we open value help for object field "Booking Fee"
      And we select one row in value help dialog having field 'Description' equal to 'euro'
      And sleep for 10 seconds

  @skip:node
  Scenario: Select currency for booking fee - java
    When we open value help for object field "Booking Fee"
      And we select one row in value help dialog having field 'Description' equal to 'European Euro'
      And sleep for 10 seconds

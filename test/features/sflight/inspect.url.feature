@todo
Feature: Inspect url

  Scenario: Inspect several urls
    Given we have started the application
      And we have inspected url "/"
      And we have inspected url "/travel_processor/webapp/index.html"
      And we have inspected url "/processor/Travel"

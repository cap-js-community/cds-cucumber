# 1.119.2 introduces ValueHelp instead of calendar for "Flight Date"
@skip:1.119
@skip:1.120
@skip:1.121
Feature: Calendar handling

  Background: Prepare the application
    Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
    When we create draft
      And we create new item for table in section "Bookings"
      And we tap on row 1 in table "Bookings"
      And we open value help for object field "Flight Date"

  Scenario: Fly next month
    When we roll calendar to "next month"
      And we select day "15"

  Scenario: Fly next year
    When we roll calendar to "next year"
      And we select day "15"

  Scenario: Fly in 2030
    When we select year "2030"
      And we select day "15"

  Scenario: Fly next year in december
    When we roll calendar to "next year"
      And we select month "December"
      And we select day "15"

Feature: Try out debugger

  Scenario: Simple scenario to debug
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we wait 120 seconds for debugger to attach
      And we list all tiles

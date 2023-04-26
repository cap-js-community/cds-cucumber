Feature: Authenticate

  Scenario: Check home
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we get the title of the page
    Then we expect the result to be "Home"

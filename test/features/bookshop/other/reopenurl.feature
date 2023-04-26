Feature: Re-open url

  Scenario: Re-open home
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
      And we have opened the url "/admin"
      And we have opened the url "fiori-apps.html"
    When we get the title of the page
    Then we expect the result to be "Home"

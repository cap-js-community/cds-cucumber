Feature: Filter books

  Scenario: Filter books by currency and price
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
      And we show the adapt filter dialog
      And we expect the next step to fail
      And we select field "missing" in adapt filter

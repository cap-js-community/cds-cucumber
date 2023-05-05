Feature: test books

  Scenario: short version books
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we tap on link "The Raven"
      And sleep for 2 seconds

  Scenario: short version books
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we tap on object identifier "The Raven"
      And sleep for 2 seconds

  Scenario: long version books
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we tap on "Richard Carpenter"
      And sleep for 2 seconds

  Scenario: long version books
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we tap on text "Romance"
      And sleep for 2 seconds

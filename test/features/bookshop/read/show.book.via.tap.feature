Feature: Tap on different elements to open a book

  Scenario: tap on book link to open compact book page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we tap on link "Catweazle"
      And sleep for 5 seconds

  Scenario: tap on object identifier to open detailed book page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we tap on object identifier "Catweazle"
      And sleep for 5 seconds

  Scenario: tap on link or text to open detailed book page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we tap on "Richard Carpenter"
      And sleep for 5 seconds

  Scenario: tap on ganre text to open detailed book page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we tap on text "Fantasy"
      And sleep for 5 seconds

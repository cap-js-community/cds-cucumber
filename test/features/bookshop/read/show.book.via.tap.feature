Feature: Tap on different elements to open a book

  @skip:1.110  @skip:1.111
  Scenario: tap on book link to open compact book page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we tap on link "Catweazle"
    Then we expect field "Title" to be "Catweazle"

  Scenario: tap on object identifier to open detailed book page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we tap on object identifier "Catweazle"
    Then we expect field "Title" to be "Catweazle"

  Scenario: tap on link or text to open detailed book page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we tap on "Richard Carpenter"
    Then we expect field "Title" to be "Catweazle"

  Scenario: tap on ganre text to open detailed book page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we tap on text "Fantasy"
    Then we expect field "Title" to be "Catweazle"

Feature: Click on different elements to open a book

  Scenario: click on book link to open compact book page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we click on link "Catweazle"
    Then we expect field "Title" to be "Catweazle"

  Scenario: click on object identifier to open compact book page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we click on object identifier "Catweazle"
    Then we expect field "Title" to be "Catweazle"

  Scenario: click on author link to open detailed book page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we click on link "Richard Carpenter"
    Then we expect field "Title" to be "Catweazle"

  Scenario: click on ganre text to open detailed book page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we click on text "Fantasy"
    Then we expect field "Title" to be "Catweazle"

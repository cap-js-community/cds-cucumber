@todo
Feature: Create and save a book

  Scenario: Create and save a book
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
      And we select tile "Manage Books"
      And table "Books" has 5 records
    When we create draft
      And we save the draft
      # edit will fail currently:
      And we edit current object

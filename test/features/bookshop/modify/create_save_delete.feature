Feature: Delete object instance

  Scenario: Create, save and delete a book
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we read the content of the rows in the table
      And save the result
      And we create draft
      And we save the draft
      And we delete the object instance
      And we confirm the deletion
      And we read the content of the rows in the table
    Then we expect the result to match the saved one
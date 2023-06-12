Feature: Delete object instance

  Scenario: Create, save and delete a book
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we read the content of the rows in the table
      And save the result
      And we create draft
      And we change the header field "Title" to "New title"
      And we change the field "Description" in group "General" to "Description of the new title"
      And we open value help for object field "Author"
      And we select one row in value help dialog having field "ID" equal to "Richard Carpenter"
      And we save the draft
      And we delete the object instance
      And we confirm the deletion
      And we read the content of the rows in the table
    Then we expect the result to match the saved one
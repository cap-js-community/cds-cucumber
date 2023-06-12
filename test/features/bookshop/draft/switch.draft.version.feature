Feature: Create draft with two users

  Scenario: Create draft
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we read the content of the table with bindings
      And we create draft
      And we change the header field "Title" to "Title1"
      And we change the field "Description" in group "General" to "Description1"
      And we open value help for object field "Author"
      And we select one row in value help dialog having field "ID" equal to "Richard Carpenter"
      And we save the draft
      And we read the content of the page
      And we edit current object
      And we change the header field "Title" to "Title2"
      And we read the content of the page
      And we change the field "Description" in group "General" to "Description2"
      And we read the content of the page
      And switch to active version
      And we read the content of the page
      And switch to draft version
      And we read the content of the page
      # clean up the draft
      And we discard draft
    Then we expect the result to contain the following details
      """
      {
        "Admin": {"Created By": "alice", "Changed By": "alice"},
        "Details": {"Stock": "", "Price": "", "Currency": ""},
        "General": {"Title": "Title2", "Author": "Richard Carpenter", "Genre": "", "Description": "Description2"},
        "Header": {"Title": "Title2", "Name": "Richard Carpenter"}
      }
      """

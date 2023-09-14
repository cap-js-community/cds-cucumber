Feature: Save draft

  @skip:1.112
  Scenario: Create and save a draft
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we create draft
      And we change the header field "Title" to "New title"
      And we change the field "Description" in group "General" to "Description of the new title"
      And we open value help for object field "Author"
      And we select one row in value help dialog having field "ID" equal to "Richard Carpenter"
      And we save the draft
      And we read the content of the page
    Then we expect the result to contain the following details
    """
    {
      "Admin": {"Created By": "alice", "Changed By": "alice"},
      "Details": {"Stock": "", "Price": "", "Currency": ""},
      "General": {"Title": "New title", "Author": "Richard Carpenter", "Genre": "", "Description": "Description of the new title"},
      "Header": {"Title": "New title", "Name": "Richard Carpenter"}
    }
    """

  


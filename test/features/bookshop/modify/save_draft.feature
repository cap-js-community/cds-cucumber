Feature: Save draft

  Scenario: Create and save a draft
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we create draft
      And we save the draft
      And we read the content of the page
    Then we expect the result to contain the following details
    """
    {
      "Admin": {"Created By": "alice", "Changed By": "alice"},
      "Details": {"Stock": "", "Price": "", "Currency": ""},
      "General": {"Title": "", "Author": "", "Genre": "", "Description": ""},
      "Header": {"Title": "", "Name": ""}
    }
    """

  


Feature: Create and validate content

  Scenario: Create draft
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we create draft
      And we read the content of the page
      # clean up the draft
      And we discard draft
    Then we expect the result to contain the following details
    """
      {
        "Admin": {"Created By": "alice", "Changed By": "alice"},
        "Details": {"Stock": "", "Price": "", "Currency": ""},
        "General": {"Title": "", "Author": "", "Genre": "", "Description": ""},
        "Header": {"Title": "", "Name": ""}
      }
    """

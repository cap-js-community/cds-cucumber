Feature: Add book translation

  Scenario: Change fields in book translation
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we create draft
      And we create new item for table "Translations"
      And we change the field "Locale" in the last row of table in section "Translations" to "de"
      And we change the field "Title" in the last row of table in section "Translations" to "new title"
      And we change the field "Description" in the last row of table in section "Translations" to "new description"
      And we read the content of the page
      # clean up the draft
      And we discard draft
    Then we expect the result to contain the following details
    """
      {
        "Admin": {"Created By": "alice", "Changed By": "alice"},
        "Details": {"Stock": "", "Price": "", "Currency": ""},
        "General": {"Title": "", "Author": "", "Genre": "", "Description": ""},
        "Header": {"Title": "", "Name": ""},
        "Translations": [{"Description": "new description","Locale": "de","Title": "new title"}]
      }
    """

  Scenario: Change fields in book translation
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we create draft
      And we create new item for table in section "Translations"
      And we change the field "Locale" in the last row of table in section "Translations" to "de"
      And we change the field "Title" in the last row of table in section "Translations" to "new title"
      And we change the field "Description" in the last row of table in section "Translations" to "new description"
      And we read the content of the page
      # clean up the draft
      And we discard draft
    Then we expect the result to contain the following details
    """
      {
        "Admin": {"Created By": "alice", "Changed By": "alice"},
        "Details": {"Stock": "", "Price": "", "Currency": ""},
        "General": {"Title": "", "Author": "", "Genre": "", "Description": ""},
        "Header": {"Title": "", "Name": ""},
        "Translations": [{"Description": "new description","Locale": "de","Title": "new title"}]
      }
    """

Feature: Table does not contain record

  Scenario: Missing record
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
    Then we expect table "Books" not to contain record
      """
      {
        "Author": "Unknown",
        "Title": "Not existing"
      }
      """

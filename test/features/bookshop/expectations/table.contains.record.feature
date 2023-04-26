Feature: Table contains record

  Scenario: Full record
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
    Then we expect table "Books" to contain record
      """
      {
        "Author": "Emily Brontë",
        "Currency": "£",
        "Genre": "Drama",
        "Price": {
          "currency": "GBP",
          "value": "11.11"
        },
        "Title": "Wuthering Heights"
      }
      """

  Scenario: Partial record
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
    Then we expect table "Books" to contain record
      """
      {
        "Author": "Emily Brontë",
        "Title": "Wuthering Heights"
      }
      """

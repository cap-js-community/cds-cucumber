Feature: Table contains records

  Scenario: Table "Books" contains two specific books
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
    Then we expect table "Books" to contain records
      """
      [
        { "Author": "Emily Brontë", "Title": "Wuthering Heights" },
        { "Author": "Charlotte Brontë", "Title": "Jane Eyre" }
      ]
      """

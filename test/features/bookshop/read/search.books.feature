Feature: Search in all fields

  Scenario: search for text in all fields
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
      And we perform basic search for "raven"
      And we read the content of the rows in the table
    Then we expect the result to contain the following details
    """
      [
        {
          "Author": "Edgar Allen Poe",
          "Currency": "$",
          "Genre": "Mystery"
        }
      ]
    """

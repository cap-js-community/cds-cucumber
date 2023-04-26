Feature: Filter books

  Scenario: Filter books by currency and price
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
      And we filter by "Currency" equal to "GBP"
      And we filter by "price" greater than 12
      And we apply the search filter
      And we read the content of the rows in the table
    Then we expect the result to contain the following details
    """
    [
      {
        "Author": "Charlotte Brontë",
        "Currency": "£",
        "Genre": "Drama",
        "Price": {
          "currency": "GBP",
          "value": "12.34"
        },
        "Title": "Jane Eyre"
      }
    ]
    """

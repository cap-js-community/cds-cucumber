Feature: Filter books

  Scenario: Filter books by currency and price
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
      And we show the adapt filter dialog
      And we select field "Genre" in adapt filter
      And we apply the adapt filter
      And we open value help for filter field "Genre"
      And we select one row in value help dialog having field "ID" equal to "Drama"
      And we confirm value help dialog
      And we apply the search filter
      And we read the content of the rows in the table
    Then we expect the result to contain the following details
    """
    [
      {
        "Author": "Emily Brontë",
        "Currency": "£",
        "Genre": "Drama",
        "Price": {
          "currency": "GBP",
          "value": "11.11"
        },
        "Title": "Wuthering Heights"
      },
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

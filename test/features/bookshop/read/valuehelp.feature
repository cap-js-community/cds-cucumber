Feature: Use Value Helper

  Scenario: Filter books by currency and price
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we open value help for filter field "Author"
      And we select one row in value help dialog having field "ID" equal to "Richard Carpenter"
      And we confirm value help dialog
      And we apply the search filter
      And we read the content of the rows in the table
    Then we expect the result to contain the following details
    """
    [
      {
        "Author": "Richard Carpenter",
        "Currency": "¥",
        "Genre": "Fantasy",
        "Price": {
          "currency": "JPY",
          "value": "150"
        },
        "Stock": "22",
        "Title": {
          "marker": "Flagged",
          "text": "Catweazle"
        }
      }
    ]
    """

  Scenario: Filter books by currency and price
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we open value help for filter field "Author"
      And we select one row in value help dialog having field "ID" equal to "Richard Carpenter"
      And we select additional row in value help dialog having field "ID" equal to "Edgar Allen Poe"
      And we confirm value help dialog
      And we apply the search filter
      And we read the content of the rows in the table
    Then we expect the result to contain the following details
    """
    [
      {
        "Author": "Edgar Allen Poe",
        "Currency": "$",
        "Genre": "Mystery",
        "Price": {
          "currency": "USD",
          "value": "13.13"
        },
        "Stock": "333",
        "Title": {
          "marker": "Flagged",
          "text": "The Raven"
        }
      },
      {
        "Author": "Edgar Allen Poe",
        "Currency": "$",
        "Genre": "Romance",
        "Price": {
          "currency": "USD",
          "value": "14"
        },
        "Stock": "555",
        "Title": {
          "marker": "Flagged",
          "text": "Eleonora"
        }
      },
      {
        "Author": "Richard Carpenter",
        "Currency": "¥",
        "Genre": "Fantasy",
        "Price": {
          "currency": "JPY",
          "value": "150"
        },
        "Stock": "22",
        "Title": {
          "marker": "Flagged",
          "text": "Catweazle"
        }
      }
    ]
    """

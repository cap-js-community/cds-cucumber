Feature: Mixed UI with OData steps

  Scenario: List all books
    Given we have started the application
      And we have connected to service CatalogService as user "alice" with password ""
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
      And we read all records from entity Books
    Then we expect to have 5 records
      And we expect table "Books" to contain the following rows
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
        },
        {
          "Author": "Edgar Allen Poe",
          "Currency": "$",
          "Genre": "Mystery",
          "Price": {
            "currency": "USD",
            "value": "13.13"
          },
          "Title": "The Raven"
        },
        {
          "Author": "Edgar Allen Poe",
          "Currency": "$",
          "Genre": "Romance",
          "Price": {
            "currency": "USD",
            "value": "14"
          },
          "Title": "Eleonora"
        },
        {
          "Author": "Richard Carpenter",
          "Currency": "¥",
          "Genre": "Fantasy",
          "Price": {
            "currency": "JPY",
            "value": "150"
          },
          "Title": "Catweazle"
        }
      ]
      """

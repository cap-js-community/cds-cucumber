Feature: Order details

  Scenario: Read order details
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Orders"
      And we apply the search filter
      And we click on text "1"
      And we read the content of the page
    Then we expect the result to contain the following details
      """
      {
        "Details": {"Currency": "Euro (EUR)"},
        "Header": {
          "Order Number": "1",
          "Created By": "john.doe@test.com",
          "Created By": "john.doe@test.com",
          "Changed By": "anonymous"
        },
        "Order Items": [
          {
            "Product ID": "201",
            "Product Title": "Wuthering Heights",
            "Quantity": "1",
            "Unit Price": "11.11"
          },
          {
            "Product ID": "271",
            "Product Title": "Catweazle",
            "Quantity": "1",
            "Unit Price": "15"
          }
        ],
        "head": [
          {"data": ["Created", {"text": "john.doe@test.com"}],
            "title": "Created"},
          {"data": ["Modified", {"text": "anonymous"}],
            "title": "Modified"}
        ]
      }
      """


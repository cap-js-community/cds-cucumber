Feature: Create new LineItem

  Scenario: Add new order item
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Orders"
      And we apply the search filter
      And we click on text "1"
      And we read the content of the page
      And we edit current object
      And we select all rows in table "Order Items"
      And we delete selected rows in table "Order Items"
      And we confirm the deletion
      And we create new item for table "Order Items"
      And we change the identification field "Quantity" to "100"
      And we change the identification field "Product" to "New product"
      And we read the content of the page
      And we apply the changes
      And we read the content of the page
      # clean up the draft
      And we discard draft
    Then we expect the result to contain the following details
    """
    {
      "Details": {
          "Currency": "Euro (EUR)"
      },
      "Header": {
          "Order Number": "1",
          "Created By": "john.doe@test.com",
          "Changed By": "anonymous"
      },
      "Order Items": [
        {
          "Product ID": "",
          "Product Title": "New product",
          "Quantity": "100",
          "Unit Price": ""
        }
      ]
    }
    """

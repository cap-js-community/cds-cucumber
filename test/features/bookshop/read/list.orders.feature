Feature: List orders

  Scenario: Apply initial filter to read all orders
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Orders"
      And we apply the search filter
      And we read the content of the rows in the table
    Then we expect the result to contain the following details
    """
    [
      {
        "Currency": "€",
        "Customer": "jane.doe@test.com",
        "Order Number": "2"
      },
      {
        "Currency": "€",
        "Customer": "john.doe@test.com",
        "Order Number": "1"
      }
    ]
    """

  Scenario: Reading orders without applying the initial filter receives empty list
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Orders"
      And we read the content of the rows in the table
    Then we expect the result to contain the following details
    """
    []
    """

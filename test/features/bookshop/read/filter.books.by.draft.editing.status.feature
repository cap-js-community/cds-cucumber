Feature: Change draft editing state

  Scenario: Filter books by currency and price
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we open value help for filter field "Editing Status"
      And we select draft editing status "Locked by Another User"
      And we apply the search filter
      And we read the content of the rows in the table
    Then we expect the result to contain the following details
    """
    []
    """

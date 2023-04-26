Feature: Adapt filter 

  Scenario: Manage Books - select all fields in adapt filter
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we show the adapt filter dialog
      And we select all fields in adapt filter
      And we apply the adapt filter
      And we read the content of the rows in the table

  Scenario: Manage Orders - select all fields in adapt filter
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Orders"
      And we show the adapt filter dialog
      And we select all fields in adapt filter
      And we apply the adapt filter
      And we read the content of the rows in the table

  Scenario: Manage Authors - select all fields in adapt filter
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Authors"
      And we show the adapt filter dialog
      And we select all fields in adapt filter
      And we apply the adapt filter
      And we read the content of the rows in the table

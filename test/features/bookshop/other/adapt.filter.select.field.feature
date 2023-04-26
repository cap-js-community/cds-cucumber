Feature: Adapt filter 

  Scenario: short version books
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we show the adapt filter dialog
      And we select field "Description" in adapt filter
      And we select field "Genre" in adapt filter
      And we select field "Number of Reviews" in adapt filter
      And we select field "Rating" in adapt filter
      And we select field "Stock" in adapt filter
      And we select field "Title" in adapt filter
      And we apply the adapt filter
      And we read the content of the rows in the table

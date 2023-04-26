Feature: Create and discard a draft

  Scenario: Create draft
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we read the content of the table with bindings
      And we create draft
      And we change the header field "Title" to "Title1"
      And we change the field "Description" in group "General" to "Description1"
      And we save the draft
      And we read the content of the page
      And we edit current object
      And we change the header field "Title" to "Title2"
      And we read the content of the page
      And we change the field "Description" in group "General" to "Description2"
      And we read the content of the page
      And we navigate back
      And we decide to keep the draft
      And we read the content of the rows in the table
      And we have opened the url "fiori-apps.html"
      And we login with user "carol" using path "/admin"
      And we select tile "Manage Books"
      And we read the content of the rows in the table
      # clean up the draft
      And we have opened the url "fiori-apps.html"
      And we login with user "alice" using path "/admin"
      And we select tile "Manage Books"
      And we read the content of the rows in the table
      And we tap on object identifier "Title2"
      And we discard draft

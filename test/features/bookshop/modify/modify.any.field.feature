Feature: Modify any field

  Scenario: Modify field Author having ValueHelp dialog
    Given we have started the CAP application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we create draft
      And we change field "Title" to "new title"
      And we modify field "Author" to "Richard Carpenter"
      And we save the draft

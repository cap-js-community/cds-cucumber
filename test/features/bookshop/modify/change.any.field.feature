Feature: Change any field

  Try to locate a field in any section

  Scenario: Change form field
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we read the content of the table with bindings
      And we create draft
      And we change field "Title" to "Title1"
      And we change field "Description" to "Description1"
      And we change field "Stock" to "10"
      And we change field "Price" to "100"
      And we change field "Currency" to "EUR"

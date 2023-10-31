Feature: Test has ValueHelp step

  Scenario: Check if fields have ValueHelp
    Given we have started the CAP application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And field "Editing Status" has value help
      And field "ID" has value help
      And field "Author" has value help
      And field "Price" has value help
      And field "Currency" has value help
      And we create draft
    Then field "Title" has no value help
      And field "Name" has no value help
      And field "Genre" has value help
      And field "Description" has no value help
      And field "Author" has value help
      And field "Stock" has no value help
      And field "Currency" has value help
      And field "Price" has value help

  Scenario: Check ValueHelp in filter dialog
    Given we have started the CAP application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we create draft
    Then we open value help for field "Author"
      And we press button "Show Filters"
      And field "Name" has value help
      And we open value help for field "Name"

  Scenario: Modify field Price via ValueHelp
    Given we have started the CAP application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we create draft
    Then we modify field "Price" to "123"
      And we open value help for field "Price"
      And we select one row in value help dialog having field 'Currency Code' equal to 'EUR'

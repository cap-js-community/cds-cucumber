Feature: Create new LineItem

  Scenario: Add new order item
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we create draft
      And we open value help for field "Author"
      And we press button "Show Filters"
      And we open value help for field "Name"
      And we press button "OK" in active dialog
      And we press button "Cancel" in active dialog
      And we discard draft
    Then we expect table "Books" to have 5 records

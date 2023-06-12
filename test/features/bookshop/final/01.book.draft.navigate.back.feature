Feature: Create draft and navigate back

  Background: Start service and open landing page
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"

  Scenario: Create draft and go back
    Given we select tile "Manage Books"
      And table "Books" has 5 records
    When we create draft
      And we navigate back
    Then we expect table "Books" to have 5 records in total

  Scenario: Create, change and keep a book draft
    Given we select tile "Manage Books"
      And table "Books" has 5 records
    When we create draft
      And we change the header field "Title" to "new book"
      And we navigate back
      And we decide to keep the draft
    Then we expect table "Books" to have 6 records in total
      And we expect table "Books" to contain record
      """
      { "Author": "", "Title": { "marker": "Draft", "text": "new book" } }
      """

  Scenario: Create, change and discard a book draft
    Given we select tile "Manage Books"
      And table "Books" has 5 records
    When we create draft
      And we change the header field "Title" to "new book"
      And we navigate back
      And we decide to discard the draft
    Then we expect table "Books" to have 5 records in total
      And we expect table "Books" to contain the following rows
      """
      [
      { "Author": "Emily Brontë", "Title": { "text": "Wuthering Heights" } },
      { "Author": "Charlotte Brontë", "Title": { "text": "Jane Eyre" } },
      { "Author": "Edgar Allen Poe", "Title": { "text": "The Raven" } },
      { "Author": "Edgar Allen Poe", "Title": { "text": "Eleonora" } },
      { "Author": "Richard Carpenter", "Title": { "text": "Catweazle" } }
      ]
      """

  Scenario: Create, change and save a book draft
    Given we select tile "Manage Books"
      And table "Books" has 5 records
    When we create draft
      And we change the header field "Title" to "new book"
      And we change the field "Description" in group "General" to "Description of the new book"
      And we open value help for object field "Author"
      And we select one row in value help dialog having field "ID" equal to "Richard Carpenter"
      And we navigate back
      And we decide to save the draft
    Then we expect table "Books" to have 6 records in total
      And we expect table "Books" to contain record
      """
      { "Author": "Richard Carpenter", "Title": { "marker": "Flagged", "text": "new book" } }
      """

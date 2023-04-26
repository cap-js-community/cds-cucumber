@todo
Feature: Create draft twice fails currently

  Scenario: Create draft
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we create draft
      And we change the header field "Title" to "Title1"
      And we navigate back
      And we decide to keep the draft
      And we create draft
      And we read the content of the page
    Then we expect the result to contain the following details
    """
      {
        "Admin": [{"Created By": "alice"},{},{"Changed By": "alice"},{}],
        "Details": [{"Stock": ""},{"Price": ""},{"Currency": ""}],
        "General": [{"Title": ""},{"Author": ""},{"Genre": ""},{"Description": ""}],
        "Header": [{"Title": ""},{"Name": ""}],
        "Translations": [],
        "head": []
      }
    """
      And we discard draft

@todo
Feature: Manage authors

  Scenario: long version authors
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Authors"
      And we click on object identifier "Richard Carpenter"
      And we read the content of the page
    Then we expect the result to contain the following details
    """
    {"fails":true}
    """

  Scenario: long version authors
    Given we have opened the url "fiori-apps.html"
      And we login with user "alice" using path "/admin"
    When we select tile "Manage Authors"
      And we click on text "Boston, Massachusetts"
      And we read the content of the page
    Then we expect the result to contain the following details
    """
    {"fails":true}
    """

@todo
Feature: Click on an author link in Manage Authors

  Scenario: Click on an author link
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Authors"
      And we click on object identifier "Richard Carpenter"
      And we read the content of the page

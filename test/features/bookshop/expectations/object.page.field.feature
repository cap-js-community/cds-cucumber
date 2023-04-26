Feature: Find field in structure

  Scenario: Check fields for book "The Raven"
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
      And we click on link "The Raven"
    Then we expect field "Title" to be "The Raven"
      And we expect field "Name" to be "Edgar Allen Poe"
      And we expect field "Price" to be "13.13 USD"
      And we expect field "Currency" to be "$"

Feature: List tiles

  Scenario: List all tiles
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we list all tiles
    Then we expect the result to match array ignoring element order
    """
    [
      "Browse Books",
      "Browse Genres (OData v2)",
      "Manage Books",
      "Manage Authors",
      "Manage Orders"
    ]
    """
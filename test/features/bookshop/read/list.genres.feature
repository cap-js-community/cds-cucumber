@todo
Feature: List genres

  Scenario: List genres
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Genres (OData v2)"
      And we read the content
    Then we expect the result to contain the following details
      """
      [
        [
          "Fiction", ""
        ],
        [
          "Drama", "Fiction"
        ],
        [
          "Poetry", "Fiction"
        ],
        [
          "Fantasy", "Fiction"
        ],
        [
          "Science Fiction", "Fiction"
        ],
        [
          "Romance", "Fiction"
        ],
        [
          "Mystery", "Fiction"
        ],
        [
          "Thriller", "Fiction"
        ],
        [
          "Dystopia", "Fiction"
        ],
        [
          "Fairy Tale", "Fiction"
        ],
        [
          "Non-Fiction", ""
        ],
        [
          "Biography", "Non-Fiction"
        ],
        [
          "Essay", "Non-Fiction"
        ],
        [
          "Speech", "Non-Fiction"
        ]
      ]
      """

Feature: Navigate to an object instance

  Scenario: Show book "The Raven"
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
      And we click on link "The Raven"
      And we read the content of the page
    Then we expect the result to contain the following details
      """
      {
        "Details": { "Price": "13.13 USD", "Currency": "$" },
        "Header": {
          "Title": "The Raven",
          "Name": "Edgar Allen Poe",
          "Description": "\"The Raven\" is a narrative poem by American writer Edgar Allan Poe. First published in January 1845, the poem is often noted for its musicality, stylized language, and supernatural atmosphere. It tells of a talking raven's mysterious visit to a distraught lover, tracing the man's slow fall into madness. The lover, often identified as being a student, is lamenting the loss of his love, Lenore. Sitting on a bust of Pallas, the raven seems to further distress the protagonist with its constant repetition of the word \"Nevermore\". The poem makes use of folk, mythological, religious, and classical references."
        }
      }
      """

  Scenario: Show book "The Raven"
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
      And we click on object identifier "The Raven"
      And we read the content of the page
    Then we expect the result to contain the following details
      """
      {
        "Details": { "Price": "13.13 USD", "Currency": "$" },
        "Header": {
          "Title": "The Raven",
          "Name": "Edgar Allen Poe",
          "Description": "\"The Raven\" is a narrative poem by American writer Edgar Allan Poe. First published in January 1845, the poem is often noted for its musicality, stylized language, and supernatural atmosphere. It tells of a talking raven's mysterious visit to a distraught lover, tracing the man's slow fall into madness. The lover, often identified as being a student, is lamenting the loss of his love, Lenore. Sitting on a bust of Pallas, the raven seems to further distress the protagonist with its constant repetition of the word \"Nevermore\". The poem makes use of folk, mythological, religious, and classical references."
        }
      }
      """

  Scenario: Click on component with specific text
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Browse Books"
      And we click on text "Richard Carpenter"
      And we read the content of the page
    Then we expect the result to contain the following details
      """
      {
        "Details": { "Price": "150 JPY", "Currency": "¥" },
        "Header": {
          "Title": "Catweazle",
          "Name": "Richard Carpenter",
          "Description": "Catweazle is a British fantasy television series, starring Geoffrey Bayldon in the title role, and created by Richard Carpenter for London Weekend Television. The first series, produced and directed by Quentin Lawrence, was screened in the UK on ITV in 1970. The second series, directed by David Reid and David Lane, was shown in 1971. Each series had thirteen episodes, most but not all written by Carpenter, who also published two books based on the scripts."
        }
      }
      """

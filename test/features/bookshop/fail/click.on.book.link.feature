@todo
Feature: Click on a book link in Manage Books

  Scenario: Create draft
    Given we have started the application
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
      And we click on link "The Raven"
      And we read the content
    Then we expect the result to contain the following details
    """
{
  "Description": "\"The Raven\" is a narrative poem by American writer Edgar Allan Poe. First published in January 1845, the poem is often noted for its musicality, stylized language, and supernatural atmosphere. It tells of a talking raven's mysterious visit to a distraught lover, tracing the man's slow fall into madness. The lover, often identified as being a student, is lamenting the loss of his love, Lenore. Sitting on a bust of Pallas, the raven seems to further distress the protagonist with its constant repetition of the word \"Nevermore\". The poem makes use of folk, mythological, religious, and classical references.",
  "Details": [
    {
      "Price": "13.13 USD"
    },
    {
      "Currency": "$"
    }
  ],
  "Header": [
    {
      "Title": "The Raven"
    },
    {
      "Name": "Edgar Allen Poe"
    }
  ]
}
    """

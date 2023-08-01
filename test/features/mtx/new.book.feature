Feature: Newly created book for specific tenant is not present in another tenant

  Scenario: Create one book in tenant "t1" and assure its absence in tenant "t2"
    Given we have started MTX service
      And we have started the CAP application
      And we subscribe tenant "t1" with user "alice"
      And we subscribe tenant "t2" with user "erin"
      And we have opened the url "/" with user "alice"
    When we select tile "Manage Books"
      And we create draft
      And we change the header field "Title" to "Alice In Wonderland"
      And we change the field "Description" in group "General" to "Description of the new title"
      And we open value help for object field "Author"
      And we select one row in value help dialog having field "ID" equal to "Richard Carpenter"
      And we save the draft
      And we navigate back
    Then we expect table "Books" to contain record
      """
      {"Title":{"text":"Alice In Wonderland"}}
      """
      And we quit
    Given we have opened the url "/" with user "erin"
    When we select tile "Manage Books"
    Then we expect table "Books" not to contain record
      """
      {"Title":{"text":"Alice In Wonderland"}}
      """
      And we unsubscribe tenant "t1" with user "alice"
      And we unsubscribe tenant "t2" with user "erin"

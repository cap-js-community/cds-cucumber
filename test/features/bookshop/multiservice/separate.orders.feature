@todo
Feature: List tiles

  Scenario: List all tiles
    Given we have started application "orders" in path "cloud-cap-samples"
      And we have started application "fiori" in path "cloud-cap-samples"
      And we have opened the url "fiori-apps.html" with user "alice"
    When we select tile "Manage Books"
#    When find protected data source

Feature: Start MTX sidecar

  Scenario: Just start MTX sidecar (1)
    Given we have started MTX service
      And we have started the CAP application
      And we subscribe tenant "t1" with user "alice"
      And we subscribe tenant "t2" with user "erin"
      And we unsubscribe tenant "t1" with user "alice"
      And we unsubscribe tenant "t2" with user "erin"

  Scenario: Just start MTX sidecar (2)
    Given we have started MTX service
      And we have started the CAP application
      And we subscribe tenant "t1" with user "alice"
      And we subscribe tenant "t2" with user "erin"
      And we unsubscribe tenant "t1" with user "alice"
      And we unsubscribe tenant "t2" with user "erin"

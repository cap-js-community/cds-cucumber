Feature: get result keys

  Background: connect to service
    Given we have started embedded server
      And we have connected to service bookshop

  Scenario: get result keys for one record
    Given we have created a new empty record in entity ManyKeys
    When we delete the record

  Scenario: get result keys for an array of records
    Given we have created a new empty record in entity ManyKeys
      And we have created a new empty record
    When we read all records
      And we delete the records

Feature: Use remote service

  Background: Prepare application
    Given we have started the application

  Scenario: Connect to remote service
    Given we have connected to service VegaService
    When read all records in entity LocalizedData
    Then we expect the result to contain the following details
    """
    [ { "ID": 1 } ]
    """

  Scenario: Connect to remote service as an authorized user
    Given we have connected to service VegaService as user "administrator" with password "admin123"
    When read all records in entity LocalizedData
    Then we expect the result to contain the following details
    """
    [ { "ID": 1 } ]
    """

  Scenario: Connect to remote service as an authorized user again
    Given we have connected to service VegaService as user "administrator" with password "admin123"
    When read all records in entity LocalizedData
    Then we expect the result to contain the following details
    """
    [ { "ID": 1 } ]
    """

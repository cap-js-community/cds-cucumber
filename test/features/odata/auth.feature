Feature: Init embedded server

  Background: Prepare service
    Given we have started embedded server

  Scenario: Just start embedded server
    Given we have connected to service VegaService
    When read all records in entity LocalizedData
    Then we expect the result to contain the following details
    """
    [ { "ID": 1 } ]
    """

  Scenario: connect as an authorized user
    Given we have connected to service VegaService as user "administrator" with password "admin123"
    When read all records in entity LocalizedData
    Then we expect the result to contain the following details
    """
    [ { "ID": 1 } ]
    """

  Scenario: connect as an authorized user again
    Given we have connected to service VegaService as user "administrator" with password "admin123"
    When read all records in entity LocalizedData
    Then we expect the result to contain the following details
    """
    [ { "ID": 1 } ]
    """

Feature: query builder

  Background: connect to service
    Given we have started embedded server
    Given we have connected to service bookshop

  Scenario: try query builder
    Given we have created a new empty record in entity KeepEmpty
    When we prepare to read entity KeepEmpty
      And select its id
      And do perform the read
    Then we expect to have 1 records

  Scenario: try query builder referencing a result
    Given we have created a new empty record in entity KeepEmpty
    When we prepare to read this record
      And select its id
      And do perform the read
    Then we expect to succeed

  @todo:remote
  # expected result do not match
  Scenario: query builder with expand
    Given we have created a new record in entity AssociationTarget
      """
      {"idx":22, "name":"associated"}
      """
      And we have created a new record in entity WithAssociation
      """
      {"idx":222, "associated_idx":22, "associatedAgain_idx":22, "name":"reference-associated"}
      """
    When we prepare to read entity WithAssociation
      And expand field associated
      And expand field associatedAgain
      And do perform the read
    Then we expect the result to contain the following details
    """
    [ { 
      "associated": { "idx": 22, "name": "associated" },
      "associatedAgain": { "idx": 22, "name": "associated" }
      } ]
    """

  @todo:remote
  #      Error: Feature not supported: SELECT statement with .groupBy
  #         at getOptions (.../node_modules/@sap/cds/libx/odata/cqn2odata.js:490:45)
  Scenario: query builder with group by and count of records
    Given we have created new records in entity Categories
    """
    [{"number":22,"category":1000},
    {"number":33,"category":1000}]
    """
    When we prepare to read entity Categories
      And field category equals 1000
      And select its category
      And select the count of records
      And group by category
      And do perform the read
    Then we expect the result to match
      """
      [ { "category": 1000, "$count": 2 } ]
      """

  @todo:remote
  # record IDs returned
  Scenario: limit count of records full match
    Given we have created new records in entity Limit
    """
    [{"number":1},{"number":2},{"number":3}]
    """
    When we prepare to read entity Limit
      And select its number
      And order by number
      And limit to 2 records
      And do perform the read
    Then we expect to have 2 records
      And we expect the result to match
      """
      [{"number":1},{"number":2}]
      """

  Scenario: limit count of records partial match
    Given we have created new records in entity Limit
    """
    [{"number":1},{"number":2},{"number":3}]
    """
    When we prepare to read entity Limit
      And select its number
      And order by number
      And limit to 2 records
      And do perform the read
    Then we expect to have 2 records
      And we expect the result to match partially
      """
      [{"number":1},{"number":2}]
      """

  @todo:remote
  Scenario: limit with offset full match
    Given we have created new records in entity Offset
    """
    [{"number":1},{"number":2},{"number":3},{"number":4},{"number":5}]
    """
    When we prepare to read entity Offset
      And select its number
      And order by number
      And limit to 2 records
      And skip first 2 records
      And do perform the read
    Then we expect to have 2 records
      And we expect the result to match
      """
      [{"number":3},{"number":4}]
      """

  Scenario: limit with offset partial match
    Given we have created new records in entity Offset
    """
    [{"number":1},{"number":2},{"number":3},{"number":4},{"number":5}]
    """
    When we prepare to read entity Offset
      And select its number
      And order by number
      And limit to 2 records
      And skip first 2 records
      And do perform the read
    Then we expect to have 2 records
      And we expect the result to match partially
      """
      [{"number":3},{"number":4}]
      """

  @todo:remote
  #      Error: Feature not supported: SELECT statement with .groupBy
  #         at getOptions (.../node_modules/@sap/cds/libx/odata/cqn2odata.js:490:45)
  Scenario: aggregate using sum
    Given we have created new records in entity Sum
    """
    [ {"number":1,"category":1}, {"number":3,"category":2},
      {"number":2,"category":1}, {"number":4,"category":2} ]
    """
    When we prepare to read entity Sum
      And aggregate number using sum
      And aggregate number into numbers using sum
      And group by category
      And select its category
      And do perform the read
    Then we expect the result to match
      """
      [{"numbers": 3, "$sum": 3, "category":1},{"numbers": 7, "$sum": 7, "category":2}]
      """

  @todo:remote
  #     Error: Feature not supported: SELECT statement with .groupBy
  #         at getOptions (.../node_modules/@sap/cds/libx/odata/cqn2odata.js:490:45)  
  Scenario: query builder with aggregate and expand with select
    Given we have created new records in entity AggregateExpandAssociated
      """
      [ {"idx":"00000000-0000-0000-0000-000000000011", "name":"one"}, {"idx":"00000000-0000-0000-0000-000000000022", "name":"two"} ]
      """
      And we have created new records in entity AggregateExpand
      """
      [
        {"idx":"00000000-0000-0000-0000-000000001111", "associated_idx":"00000000-0000-0000-0000-000000000011", "price": 1 },
        {"idx":"00000000-0000-0000-0000-000000001112", "associated_idx":"00000000-0000-0000-0000-000000000011", "price": 2 },
        {"idx":"00000000-0000-0000-0000-000000002221", "associated_idx":"00000000-0000-0000-0000-000000000022", "price": 3 },
        {"idx":"00000000-0000-0000-0000-000000002222", "associated_idx":"00000000-0000-0000-0000-000000000022", "price": 4 }
      ]
      """
    When we prepare to read entity AggregateExpand
      And expand field associated by selecting its name
      And group by associated.idx
      And aggregate price into total using sum
      And do perform the read
    Then we expect the result to contain the following details
    """
    [ 
      { "associated": { "name": "one" }, "total": 3},
      { "associated": { "name": "two" }, "total": 7}
    ]
    """

  @todo:remote
  Scenario: query builder with aggregate and expand with select - no GUIDs
    Given we have created new records in entity AggregateExpandAssociated
      """
      [ {"idx":11, "name":"one"}, {"idx":22, "name":"two"} ]
      """
      And we have created new records in entity AggregateExpand
      """
      [
        {"idx":1111, "associated_idx":11, "price": 1 },
        {"idx":1112, "associated_idx":11, "price": 2 },
        {"idx":2221, "associated_idx":22, "price": 3 },
        {"idx":2222, "associated_idx":22, "price": 4 }
      ]
      """
    When we prepare to read entity AggregateExpand
      And expand field associated by selecting its name
      And group by associated.idx
      And aggregate price into total using sum
      And do perform the read
    Then we expect the result to contain the following details
    """
    [ 
      { "associated": { "name": "one" }, "total": 3},
      { "associated": { "name": "two" }, "total": 7}
    ]
    """

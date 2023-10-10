Feature: crud

  Background: connect to service
    Given we have started embedded server
      And we have connected to service bookshop

  # create
  Scenario: test create new record

    Create records using different create-steps

    Given we have created a new empty record in entity BooksWithUUID
      And we have created a new empty record
      And we have created a new record
        """
        {"name":"test"}
        """
      And we have created a new record in entity BooksWithUUID
        """
        {"name":"test with uuid"}
        """
    When we read all records
    Then we expect to have 4 records

  # read

  Scenario: read records selecting one field
    Given we have created a new record in entity BooksWithUUID
      """
      {"name":"test1234"}
      """
    When we read entity BooksWithUUID by selecting name
    Then we expect the result to contain the following record
      """
      {"name":"test1234"}
      """

  Scenario: read records selecting two fields
    Given we have created a new record in entity BooksWithUUID
      """
      {"name":"test1234"}
      """
    When we read entity BooksWithUUID by selecting the following fields
      """
      name, id
      """
    Then we expect the result to contain the following record
      """
      {"name":"test1234"}
      """

  @todo:remote
  # alias appended to the column name as string
  Scenario: read records selecting two fields with aliases
    Given we have created a new record in entity BooksWithUUID
      """
      {"name":"test1234"}
      """
    When we read entity BooksWithUUID by selecting the following fields
      """
      name, id, name as name1, id as id1
      """
    Then we expect the result to contain the following record
      """
      {"name":"test1234", "name1":"test1234"}
      """

  Scenario: read by expand single field
    Given we have created a new record in entity AssociationTarget
      """
      {"idx":1, "name":"associated"}
      """
      And we have created a new record in entity WithAssociation
      """
      {"idx":11, "associated_idx":1, "name":"reference-associated"}
      """
    When we read entity WithAssociation by expanding associated
    Then we expect the result to contain the following details
    """
    [{"associated": {"idx":1, "name": "associated"}}]
    """

  Scenario: composition deep-insert
    Given we have created a new record in entity WithComposition
    """
    {"name":"parent1", "items":[{"name":"child1"}]}
    """
    When we read entity WithComposition by expanding items
    Then we expect the result to contain the following record
    """
    {"items":[{"name":"child1"}]}
    """

  # order by

  Scenario: order by - partial match
    Given we have created a new record in entity OrderBy
      """
      {"number":2}
      """
      And we have created a new record in entity OrderBy
        """
        {"number":1}
        """
    When we prepare to read entity OrderBy
      And select its number
      And order by number
      And do perform the read
    Then we expect the result to match partially
    """
    [ { "number": 1 }, { "number": 2 } ]
    """
    When we want to order descending by number
      And we read entity OrderBy by selecting number
    Then we expect the result to match partially
    """
    [ { "number": 2 }, { "number": 1 } ]
    """

  Scenario: order by - full match
    Given we have created a new record in entity OrderBy
      """
      {"number":2}
      """
      And we have created a new record in entity OrderBy
        """
        {"number":1}
        """
    When we prepare to read entity OrderBy
      And select its number
      And order by number
      And do perform the read
    Then we expect the result to contain the following details
    """
    [ { "number": 1 }, { "number": 2 } ]
    """
    When we want to order descending by number
      And we read entity OrderBy by selecting number
    Then we expect the result to contain the following details
    """
    [ { "number": 2 }, { "number": 1 } ]
    """

  # group by

  Scenario: group by
# TODO        Deserialization Error: Value for structural type must be an object.
#           at run (.../node_modules/@sap/cds/libx/_runtime/remote/utils/client.js:310:31)
    Given we have created new records in entity Categories
      """
      [
        {"number":1, "category":1},
        {"number":2, "category":1},
        {"number":3, "category":2},
        {"number":4, "category":2}
      ]
      """
# TODO {"SELECT":{"from":{"ref":["Categories"]},"columns":[{"ref":["category"]}],"groupBy":[{"ref":["category"]}]}}
#  ✖ And we read entity Categories by selecting category # ../../lib/steps/odata/crud.js:83
#       Error: Feature not supported: SELECT statement with .groupBy
#           at getOptions (.../node_modules/@sap/cds/libx/odata/cqn2odata.js:490:45)
#           at _select (.../node_modules/@sap/cds/libx/odata/cqn2odata.js:512:24)
#    When we want to group by category
#      And we read entity Categories by selecting category
    When we read entity Categories by selecting category
    Then we expect the result to contain records
    """
    [ { "category": 1 }, { "category": 2 } ]
    """

  # read - follow association

  @todo:embedded
  # returns list of records
  Scenario: read following an association
    Given we have created a new record in entity AssociationTarget
      """
      {"idx":2, "name":"associated"}
      """
      And we have created a new record in entity WithAssociation
      """
      {"idx":22, "associated_idx":2, "name":"reference-associated"}
      """
    When we read associated of entity WithAssociation with key 22
    Then we expect the result to match
      """
      {"idx":2, "name": "associated"}
      """

  @todo:remote
  # returns one record
  Scenario: read following an association
    Given we have created a new record in entity AssociationTarget
      """
      {"idx":2, "name":"associated"}
      """
      And we have created a new record in entity WithAssociation
      """
      {"idx":22, "associated_idx":2, "name":"reference-associated"}
      """
    When we read associated of entity WithAssociation with key 22
    Then we expect the result to match
      """
      [{"idx":2, "name": "associated"}]
      """

  # update

  Scenario: successful update
    Given we have created a new record in entity Books
      """
      {"id":4, "name":"initial"}
      """
    When we update the record with the following data
      """
      {"id":4, "name":"updated"}
      """
    Then we expect to succeed
      And its name to be updated

  Scenario: failing update
    Given we have created a new record in entity Books
      """
      {"id":2}
      """
    When we update the record with the following data
      """
      {"aaa":123}
      """
    Then we expect to fail

  @todo:remote
  # Record not found - expected {"name":"update+filter"} in [{"id":5,"name":"initial+update+filter"}]
  #     Expected uri token 'ODataIdentifier' could not be found in 'Books('initial+update+filter')' at position 7
  #         at run (.../node_modules/@sap/cds/libx/_runtime/remote/utils/client.js:310:31)
  Scenario: update with filter
    Given we have created a new record in entity Books
      """
      {"id":5,"name":"initial+update+filter"}
      """
  When we update records by setting "name" to "update+filter" using filter
    """
    {"name":"initial+update+filter"}
    """
    And we read all records
  Then we expect the result to contain the following record
    """
    {"name":"update+filter"}
    """

  # delete

  Scenario: successful deletion providing target entity as parameter
  
    Given we have created a new record in entity Books
      """
      {"id":6}
      """
    When we delete the record from entity Books
    Then we expect to succeed

  Scenario: successful deletion targeting implicit entity
    Given we have created a new record in entity Books
      """
      {"id":7}
      """
    When we delete the record
    Then we expect to succeed

  Scenario: delete selected records
    Given we have created a new record in entity Books
      """
      {"id":8, "name": "delete"}
      """
      And we have created a new record in entity Books
      """
      {"id":9, "name": "delete"}
      """
      And we have read records matching name equal to "delete"
    When we delete the records
    Then we expect to succeed

  Scenario: failing delete
  
    Create record in one entity but delete it from another
  
    Given we have created a new record in entity Books
      """
      {"id":8}
      """
    When we delete the record from entity BooksWithUUID
    Then we expect to fail

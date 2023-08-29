service bookshop {

  entity ForRemoteService
  {
    key id : UUID;
    name: String;
  }

  entity Books
  {
    key id : Integer;
    name: String;
  }

  entity BooksWithUUID
  {
    key id : UUID;
    name: String;
  }

  entity KeepEmpty
  {
    key id : UUID;
  }

  entity WithAssociation
  {
    key idx : Integer;
    name: String;
    associated: association to AssociationTarget;
    associatedAgain: association to AssociationTarget;
  }

  entity AssociationTarget
  {
    key idx: Integer;
    name: String;
  }

  entity ManyKeys
  {
    key id1: UUID;
    key id2: UUID;
    key id3: UUID;
    key id4: UUID;
    key id5: UUID;
    name1: String;
    name2: String;
    name3: String;
    name4: String;
    name5: String;
  }

  entity WithComposition
  {
    key id:UUID;
    name: String;
    items: composition of many WithCompositionItems on items.parent = $self;
  }

  entity WithCompositionItems
  {
    key id:UUID;
    name: String;
    parent: association to WithComposition;
  }

  entity OrderBy
  {
    key id:UUID;
    number: Integer;
  }

  entity Limit
  {
    key id:UUID;
    number: Integer;
  }

  entity Offset
  {
    key id:UUID;
    number: Integer;
  }

  entity Categories
  {
    key id:UUID;
    number: Integer;
    category: Integer;
  }

  entity Sum
  {
    key id:UUID;
    number: Integer;
    category: Integer;
  }

  entity AggregateExpandAssociated {
    key idx:UUID;
    name:String;
  }

  entity AggregateExpand {
    key idx:UUID;
    associated: association to AggregateExpandAssociated;
    price: Integer;
  }

}

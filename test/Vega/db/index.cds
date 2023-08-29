namespace cap.vega;

entity AllTypes {
  key id: UUID;
  intField : Integer;
  strField : String;
}

entity AutoFilledPK {
  key ID: UUID;
}

entity AutoFilledPKwithComposition {
  key ID: UUID;
  items : Composition of many AutoFilledPKItems on items.parent=$self;
}

entity AutoFilledPKItems {
  key ID : UUID;
  parent : Association to AutoFilledPKwithComposition;
}

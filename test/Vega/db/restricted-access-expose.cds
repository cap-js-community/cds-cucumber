context restricted {
  context access {

    @cds.autoexpose
    entity ExplicitlyAutoExposed { // explicitly auto-exposed (by @cds.autoexpose)
      key ID: UUID;
    }

    entity ImplicitlyAutoExposed { // implicitly auto-exposed (by composition)
      key ID: UUID;
      toExplicitlyExposed: Association to ExplicitlyAutoExposed;
      parent : Association to RestrictedAccessExposed;
    }

    entity RestrictedAccessExposed { // explicitly exposed (by projection)
      key ID: UUID;
      implicitlyExposed: Composition of many ImplicitlyAutoExposed on implicitlyExposed.parent=$self;
    }

  }
}

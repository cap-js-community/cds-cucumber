using { managed } from '@sap/cds/common';
using cap.vega as schema from '../db';
using restricted.access as expose from '../db/restricted-access-expose';

service VegaService {

  entity AllTypes as projection on schema.AllTypes;
  entity AutoFilledPK as projection on schema.AutoFilledPK;
  entity AutoFilledPKwithComposition as projection on schema.AutoFilledPKwithComposition;

  // https://github.tools.sap/cap/cross-tests/issues/154

  entity EntityImplicitSorting {
    key ID: Integer;
    intField: Integer;
  }

  entity EntityImplicitSortingWithOrderBy {
    key ID: Integer;
    intField: Integer;
  }

  entity EntityImplicitSorting4View {
    key ID: Integer;
    intField: Integer;
  }
  entity ViewImplicitSorting as select from EntityImplicitSorting4View;

  entity EntityImplicitSorting4ViewWithOrderBy {
    key ID: Integer;
    intField1: Integer;
    intField2: Integer;
  }
  entity ViewImplicitSortingWithOrderBy as select from EntityImplicitSorting4ViewWithOrderBy
    order by intField2;


  entity EntityImplicitSortingCompoundKeys {
    key dID: Integer;
    key bID: Integer;
    key cID: Integer;
    key aID: Integer;
  }

  // https://github.tools.sap/cap/cross-tests/issues/191

  entity ArrayedStringElements {
    key Id: Integer;
    Strings: many String;
    Integers: many Integer;
  }

  // https://github.tools.sap/cap/cross-tests/issues/194

  @(requires: 'authenticated-user')
  entity TestAuthRestricted  @(restrict: [ 
    { grant: ['READ','WRITE','CREATE'], to: 'admin' },
  ])
  {
    key Id: UUID;
  }

  // etags https://github.tools.sap/cap/cross-tests/issues/199
  
  entity ETags : managed {
    key ID: UUID;
    intValue: Integer;
  }
  annotate ETags with { modifiedAt @odata.etag }

  // Streaming & Media Types https://github.tools.sap/cap/cross-tests/issues/222

  entity MediaDataWithType {
    key ID: UUID;
    content : String @Core.MediaType: mimeType;
    mimeType : String @Core.IsMediaType;
  }

  entity MediaDataExternalUrl {
    key ID: UUID;
    url : String @Core.IsURL @Core.MediaType: mimeType;
    mimeType : String @Core.IsMediaType;
  }
  
  entity MediaDataContentDispositionAttachment {
    key ID: UUID;
    content : String
      @Core.MediaType: mimeType
      @Core.ContentDisposition.Filename: filename
      @Core.ContentDisposition.Type: 'attachment'
    ;
    filename : String;
    mimeType : String @Core.IsMediaType;
  }

  entity MediaDataContentDispositionInline {
    key ID: UUID;
    content : String
      @Core.MediaType: mimeType
      @Core.ContentDisposition.Filename: filename
      @Core.ContentDisposition.Type: 'inline'
    ;
    filename : String;
    mimeType : String @Core.IsMediaType;
  }

  // Access Control https://github.tools.sap/cap/cross-tests/issues/233
  
  @readonly
  entity RestrictedAccessReadOnly as projection on RestrictedAccess;

  entity RestrictedAccess
  {
    key ID: UUID;
  }

  @insertonly
  entity RestrictedAccessInsertOnly
  {
    key ID: UUID;
  }

  @Capabilities: {
    InsertRestrictions.Insertable: false,
  }
  entity RestrictedAddessCapabilitiesNotInsertable
  {
    key ID : UUID;
  }

  @Capabilities: {
    UpdateRestrictions.Updatable: false,
    DeleteRestrictions.Deletable: false
  }
  entity RestrictedAddessCapabilitiesNotModifiable
  {
    key ID: UUID;
    name: String;
  }

  // Restricted Access: expose https://github.tools.sap/cap/cross-tests/issues/233

  entity RestrictedAccessExposedProjection as projection on expose.RestrictedAccessExposed;

  // Localization, i18n https://cap.cloud.sap/docs/guides/i18n

  entity LocalizationWithTextBundles {
    key ID: UUID @title: '{i18n>LocalizedString}';
  }

  // Managed data https://cap.cloud.sap/docs/guides/providing-services#managed-data

  entity ManagedData {
    key ID: UUID;
    createdAt  : Timestamp @cds.on.insert: $now;
    createdBy  : String    @cds.on.insert: $user;
    modifiedAt : Timestamp @cds.on.insert: $now  @cds.on.update: $now;
    modifiedBy : String    @cds.on.insert: $user @cds.on.update: $user;
    payload: Integer;
  }

  // Localized data https://cap.cloud.sap/docs/guides/localized-data

  entity LocalizedData {
    key ID: Integer;
    payload: localized String;
  }

  entity LocalizedDataAssociated {
    key ID: Integer;
    payload: localized String;
    parent: association to LocalizedData;
  }

  entity LocalizedDataWithComposition {
    key ID: Integer;
    payload: localized String;
    items: composition of many LocalizedDataItems on items.parent = $self;
  }

  entity LocalizedDataItems {
    key ID: Integer;
    payload: localized String;
    parent: association to LocalizedDataWithComposition;
  }

}

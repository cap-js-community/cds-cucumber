/** @ignore **/

const { Given, When, Then } = require('@cucumber/cucumber');

// Create empty record

Given('we have created a new empty record', async function() {
  const record = {};
  this.storeResult(await this.cdsService.create(this.entity, record));
})

Given('we have created a new empty record in entity {word}', async function( entity ) {
  this.entity = entity;
  const record = {};
  this.storeResult(await this.cdsService.create(entity, record), entity);
})

Given('we have created a new record', async function( data ) {
  const record = JSON.parse(data);
  this.storeResult(await this.cdsService.create(this.entity, record), this.entity);
})

Given('we have created a new record in entity {word}', async function( entity, data ) {
  this.entity = entity;
  const record = JSON.parse(data);
  this.storeResult(await this.cdsService.create(entity, record), entity);
})

Given('we have created new records in entity {word}', async function( entity, data ) {
  this.entity = entity;
  const records = JSON.parse(data);
  // TODO        Deserialization Error: Value for structural type must be an object.
  //           at run (.../node_modules/@sap/cds/libx/_runtime/remote/utils/client.js:310:31)
  // this.storeResult(await this.cdsService.create(entity, records));
  let result = [];
  for(let record of records)
    result.push(await this.cdsService.create(entity, record));
  this.storeResult(result, entity);
})

// Create record

Given('we have created a new record with {word} set to {float}', async function( field, value ) {
  const record = { [field]: value };
  this.storeResult(await this.cdsService.create(this.entity, record));
})

Given('we have created a new record with {word} set to {string}', async function( field, value ) {
  const record = { [field]: value };
  this.storeResult(await this.cdsService.create(this.entity, record));
})

// TODO try to reduce to one step using model info -> type casting?
Given('we have created a new record with {word} set to {word}', async function( field, value ) {
  const record = { [field]: value };
  this.storeResult(await this.cdsService.create(this.entity, record));
})

// Read

Given('we have read records matching {word} equal to {string}', async function( field, value ) {
  let query = SELECT.from(this.entity).where({[field]:value});
  this.storeResult(await this.cdsService.run(query));
})

When(/^we read all records$/, async function() {
  this.storeResult(await this.cdsService.run(SELECT(this.entity)));
})

When('we read all records from entity {word}', async function( entity ) {
  this.entity = entity;
  this.storeResult(await this.cdsService.run(SELECT(entity)));
})

// fields: comma-separated list of names with optional aliases, also support expressions
// see: https://cap.cloud.sap/docs/node.js/cds-ql#select-columns
// example: field1,field1 as alias1,field1||field2 as alias2
When('we read entity {word} by selecting the following fields', async function( entity, fields ) {
  this.entity = entity;
  this.prepare.columns.push(...fields.split(',').map(F => F.trim()));
  await this.selectFrom();
})

When('we read entity {word} by selecting {word} and {word}', async function( entity, fieldName1, fieldName2 ) {
  this.entity = entity;
  this.prepare.columns.push(fieldName1, fieldName2);
  await this.selectFrom();
})

When('we read entity {word} by selecting {word}', async function( entity, fieldName ) {
  this.entity = entity;
  this.prepare.columns.push(fieldName);
  await this.selectFrom();
})

When('we read entity {word} by expanding {word}', async function( entity, associationName ) {
  this.entity = entity;
  this.prepare.columns.push({ref:[associationName], expand:['*']});
  await this.selectFrom();
})

When('we use the following filter', async function( filter ) {
  this.prepare.where = JSON.parse(filter);
})

When('we want to order ascending by {word}', async function( field ) {
  this.prepare.orderBy.push([field,'asc']);
})

When('we want to order descending by {word}', async function( field ) {
  this.prepare.orderBy.push([field,'desc']);
})

When('we want to group by {word}', async function( field ) {
  this.prepare.groupBy.push(field);
})

// Update

When('we update the record with the following data', async function( data ) {
  const record = JSON.parse(data);
  this.storeResult(await this.run(UPDATE(this.entity,this.getResultKeys()).with(record)));
})

When('we update records by setting {string} to {string} using filter', async function( field, value, filter ) {
  const record = {[field]:value};
  this.storeResult(await this.run(UPDATE(this.entity,JSON.parse(filter)).with(record)));
})

// Delete

When('we delete the record from entity {word}', async function( entity ) {
  this.storeResult(await this.run(DELETE(entity, this.getResultKeys())));
})

When('we delete matching records from entity {word}', async function( entity, filter ) {
  this.storeResult(await this.run(DELETE(entity).where(JSON.parse(filter))));
})

When('we delete the records', async function() {
  this.storeResult(await Promise.all(this.result.map(async (result) => await this.run(DELETE(this.entity, this.getResultKeys(result))))));
})

When('we delete the record', async function( ) {
  this.storeResult(await this.run(DELETE(this.entity, this.getResultKeys())));
})

// show all records - helps to test the results from the steps

Then('read all records in entity {word}', async function( entity ) {
  this.storeResult(await this.cdsService.run(SELECT.from(entity).columns('ID')));
})

Then('show result keys', async function() {
  console.log(this.getResultKeys())
})

Then('show the result', async function() {
  console.log(this.result)
})

When('we read {word} of entity {word} with key {int}', async function(association, entity, key) {
  query=cds.parse.cql(`SELECT * from ${entity}[${key}]:${association}`);
  this.storeResult(await this.run(query));
})

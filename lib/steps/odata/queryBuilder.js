/** @ignore **/

const assert = require('assert');

const { When } = require('@cucumber/cucumber');

// first operation
When('we prepare to {word} entity {word}', async function( operation, entity ) {
  this.initPrepare(operation,entity);
})

// we have entity and result already
When('we prepare to {word} this {word}', async function( operation, _ ) {
  this.initPrepare(operation);
})

When('field {word} equals {int}', async function( field, value ) {
  this.prepare.where = {[field]:value};
})

When('select its {word}', async function( field ) {
  this.prepare.columns.push(field);
})

When('select the count of records', async function() {
  this.prepare.columns.push({ func: 'count', args: [{ val: 1 }], as: '$count' });
})

When('aggregate {word} using {}', async function( field, func ) {
  this.prepare.columns.push({ func, args: [field], as: '$'+func });
})

When('aggregate {word} into {word} using {}', async function( field, alias, func ) {
  this.prepare.columns.push({ func, args: [field], as: alias });
})

When('order by {word}', async function( field ) {
  this.prepare.orderBy.push([field, 'asc']);
})

When('order descending by {word}', async function( field ) {
  this.prepare.orderBy.push([field, 'desc']);
})

When('expand field {word} by selecting its {word}', async function( associationName, field ) {
  this.prepare.expand.push({field:associationName,select:[field]});
})

When('expand field {word}', async function( associationName ) {
  this.prepare.expand.push(associationName);
})

When('group by {word}', async function( field ) {
  this.prepare.groupBy.push(field);
})

When('limit to {int} records', async function( limit ) {
  this.prepare.limit = limit;
})

When('skip first {int} records', async function( offset ) {
  this.prepare.offset = offset;
})

When('do perform the {word}', async function( operation ) {
  assert.equal(this.prepare.operation, operation);
  await this.selectFrom();
})

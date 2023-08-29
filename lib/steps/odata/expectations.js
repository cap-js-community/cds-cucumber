/** @ignore **/

const assert = require('assert');
const chai = require('chai');
chai.use(require('chai-shallow-deep-equal'));
chai.use(require("chai-sorted"));

const { Then } = require('@cucumber/cucumber');

Then('its {word} to be {word}', async function(field, value) {
  assert.equal(value, this.result[field]);
})

Then('we expect to succeed', async function() {
  assert.ok(!this.error)
})

Then('we expect to fail', async function() {
  assert.ok(this.error)
  this.error = undefined;
})

Then('we expect no data returned', async function() {
  assert.equal(this.result, undefined)
})

Then('we expect data returned', async function() {
  assert.notEqual(this.result, undefined)
})

Then('we expect to have {int} records', async function( count ) {
  assert.ok(this.result, 'No result')
  assert.ok(Array.isArray(this.result), 'The result is not an array')
  assert.equal(this.result.length, count)
})

Then('we expect the result to contain the following record', async function( expected ) {
  expected=JSON.parse(expected);
  let found = false;
  this.result.forEach(R => {
    try {
      chai.expect(R).to.shallowDeepEqual(expected);
      found=true;
    } catch (e) {}
  })
  assert.ok(found,'Record not found - expected '+JSON.stringify(expected)+' in '+JSON.stringify(this.result))
})

Then('we expect the result to match', async function( expected ) {
  assert.deepEqual(this.result, JSON.parse(expected));
})

Then('we expect the result to match partially', async function( expected ) {
  chai.expect(this.result).to.shallowDeepEqual(JSON.parse(expected));
})

Then('we expect the result to be sorted by {word}', async function( field ) {
  chai.expect(this.result).to.be.sortedBy(field) 
})

Then('we expect the result to be sorted descending by {word}', async function( field ) {
  chai.expect(this.result).to.be.sortedBy(field,{descending: true}) 
})

Then('we expect the result to contain records', async function( expected ) {
  expected=JSON.parse(expected);
  let missingRecords = [];
  expected.forEach(E => {
    let found = false;
    this.result.forEach(R => {
      try {
        chai.expect(R).to.shallowDeepEqual(E);
        found=true;
      } catch (e) {}
    })
    if(!found) missingRecords.push(E);
  })
  assert.ok(missingRecords.length==0,`Records not found: ${JSON.stringify(missingRecords)}`)
})

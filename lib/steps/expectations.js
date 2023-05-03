const assert = require('assert');
const chai = require('chai');
chai.use(require('chai-shallow-deep-equal'));

const { Then } = require('@cucumber/cucumber');

Then('we expect the result to match array ignoring element order', async function( expected ) {
  assert.deepEqual(this.result.sort(), JSON.parse(expected).sort());
})

Then('we expect the result to contain the following details', async function( expected ) {
  chai.expect(this.result).to.shallowDeepEqual(JSON.parse(expected));
})

Then('we expect the result to match the saved one', async function() {
  chai.expect(this.result).to.shallowDeepEqual(this.saved);
})

Then('we expect the result to be {string}', async function( text ) {
  assert.equal(this.result, text);
})

Then('sleep for {int} seconds', async function( seconds ) {
  await this.controller._sleep(1000*seconds);
})

Then('we expect the next step to fail', async function( ) {
  await this.controller.setExpectToFail();
})

Then('we expect table {string} to contain the following rows', async function( tableName, expected ) {
  let content = await this.controller.extractTableContent(tableName);
  chai.expect(content).to.shallowDeepEqual(JSON.parse(expected));
})

Then('we expect table {string} to contain records', async function( tableName, expected ) {
  let content = await this.controller.extractTableContent(tableName);
  expected=JSON.parse(expected);
  let missingRecords = [];
  expected.forEach(E => {
    let found = false;
    content.forEach(R => {
      try {
        chai.expect(R).to.shallowDeepEqual(E);
        found=true;
      } catch (e) {}
    })
    if(!found) missingRecords.push(E);
  })
  assert.ok(missingRecords.length==0,`Records not found: ${JSON.stringify(missingRecords)}`)
})

Then('we expect table {string} not to contain records', async function( tableName, expected ) {
  let content = await this.controller.extractTableContent(tableName);
  expected=JSON.parse(expected);
  let foundRecords = [];
  expected.forEach(E => {
    let found = false;
    content.forEach(R => {
      try {
        chai.expect(R).to.shallowDeepEqual(E);
        found=true;
      } catch (e) {}
    })
    if(found) foundRecords.push(E);
  })
  assert.ok(foundRecords.length==0,`Records found: ${JSON.stringify(foundRecords)}`)
})

Then('we expect table {string} to contain record', async function( tableName, expected ) {
  let content = await this.controller.extractTableContent(tableName);
  expected=JSON.parse(expected);
  let found = false;
  content.forEach(R => {
    try {
      chai.expect(R).to.shallowDeepEqual(expected);
      found=true;
    } catch (e) {}
  })
  assert.ok(found,`Record not found - expected:${JSON.stringify(expected)} in ${JSON.stringify(content)}`)
})

Then('we expect table {string} not to contain record', async function( tableName, unexpected ) {
  let content = await this.controller.extractTableContent(tableName);
  unexpected=JSON.parse(unexpected);
  let found = false;
  content.forEach(R => {
    try {
      chai.expect(R).to.shallowDeepEqual(unexpected);
      found=true;
    } catch (e) {}
  })
  assert.ok(!found,`Record found:${JSON.stringify(unexpected)} in ${JSON.stringify(content)}`)
})

Then('we expect table {string} to have {int} records', async function( tableName, expectedRowCount ) {
  let content = await this.controller.extractTableContent(tableName);
  assert.equal(content.length, expectedRowCount)
})

Then('we expect table {string} to have {int} records in total', async function( tableName, expectedRowCount ) {
  let totalRowCount = await this.controller.extractTableRowsTotalCount(tableName);
  assert.equal(totalRowCount, expectedRowCount)
})

Then('we expect to have {int} table records', async function( expectedRowCount ) {
  let content = await this.controller.extractTableRows();
  assert.equal(content.length, expectedRowCount)
})

function findFieldInObjectStructure(content, fieldName) {
  if(typeof content === 'object') {
    for(let key in content) {
      let value = content[key];
      if(typeof value!=='object'){
        if(key==fieldName)
          return value;
        continue;
      }
      let found = findFieldInObjectStructure(value, fieldName);
      if(found && typeof found!=='object') return found;
    }
  }
  return undefined;
}

Then('we expect field {string} to be {string}', async function( fieldName, expected ) {
  let content = await this.controller.extractCurrentPageContent();
  let found = findFieldInObjectStructure(content, fieldName);
  if(!found)
    throw Error(`Field ${fieldName} not found, fields: ${Object.keys(content)}`);
  found = found.replaceAll(' ',' '); // replace non-breaking space
  assert.equal(found, expected)
})

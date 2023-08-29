/** @ignore **/

const assert = require('assert');

const { Then } = require('@cucumber/cucumber');

function getResponse(that) {
  let error = that.error;
  that.error = undefined;
  let response = error?.error?.reason?.response
    || error?.reason?.response
    || error?.response;
  // cds embedded - no 'reason' is set, sets only 'code'
  return response || {status: error.code};
}

Then('we expect to fail with response code {int}', async function( code ) {
  assert.ok(this.error);
  let response = getResponse(this);
  assert.equal(response.status, code);
})

Then('we expect the response code to be {int}', async function ( code ) {
  let response = getResponse(this);
  assert.equal(response.status, code);
})

Then('we expect the {word} not to be modified', async function( _ ) {
  assert.equal(this.result, undefined);
  let response = getResponse(this);
  if(response.statusText)
    assert.equal(response.statusText, 'Not Modified');
  assert.equal(response.status, 304);
})

Then('we expect the access to be forbidden', async function( ) {
  assert.equal(this.result, undefined);
  let response = getResponse(this);
  if(response.statusText)
    assert.equal(response.statusText, 'Unauthorized');
  assert.equal(response.status, 401);
})

Then('we expect to be not authorized', async function( ) {
  assert.equal(this.result, undefined);
  let response = getResponse(this);
  if(response.statusText)
    assert.equal(response.statusText, 'Forbidden');
  assert.equal(response.status, 403);
})

Then('we expect the {word} be missing', async function( _ ) {
  assert.equal(this.result, undefined);
  let response = getResponse(this);
  this.error = undefined;
  if(response.statusText)
    assert.equal(response.statusText, 'Not Found');
  assert.equal(response.status, 404);
})

Then('we expect that the operation is not allowed', async function( ) {
  assert.equal(this.result, undefined);
  let response = getResponse(this);
  if(response.statusText)
    assert.equal(response.statusText, 'Method Not Allowed');
  assert.equal(response.status, 405);
})

Then('we expect the precondition to fail', async function( ) {
  assert.equal(this.result, undefined);
  let response = getResponse(this);
  if(response.statusText)
    assert.equal(response.statusText, 'Precondition Failed');
  assert.equal(response.status, 412);
})

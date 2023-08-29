const loadModel = require('../../lib/steps/common/loadModel');
const assert = require('assert');

(async function() {
  assert.equal(await loadModel({testOnly:true}),'*');
  assert.equal(await loadModel({testOnly:true,root:'root'}),'root/*');
  assert.equal(await loadModel({testOnly:true,application:'application'}),'application/*');
  assert.equal(await loadModel({testOnly:true,directory:'directory'}),'directory/*');

  assert.equal(await loadModel({testOnly:true,application:'application',directory:'directory'}),'directory/application/*');

  assert.equal(await loadModel({testOnly:true,root:'root',application:'application',directory:'directory'}),'root/directory/application/*');
})()

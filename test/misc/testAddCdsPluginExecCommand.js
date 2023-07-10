#!/bin/env node

let execCommand = require('../../cds-plugins/addCdsPlugin');
let failed=false;
(async function() {
  try {
    await execCommand('false');
  } catch (e) {
    failed=true;
  }
  if(!failed)
    throw Error('Command did not fail');
  console.log('Command failed as expected.')
})();

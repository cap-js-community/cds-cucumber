// require steps
const steps = require.resolve('../../../lib/steps');
const fs = require('fs');
const path = require('node:path');
const dir = path.dirname(steps);
const files = fs.readdirSync(dir);
files.forEach(F => {
  if(!F.endsWith('.js')) return;
  let fn = path.join(dir,F); 
  if(fs.lstatSync(fn).isDirectory()) return;
  require(fn);
});

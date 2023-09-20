const fs = require('node:fs');

const filename = 'CHANGELOG.md';

const re = /^\#\#\ Version \d+\.\d+\.\d+\ \-\ \d\d\d\d\-\d\d\-\d\d$/

const lines = fs.readFileSync(filename).toString().split('\n');

const result = lines.map((L,I) => [I,L])
  .filter(X => X[1].indexOf('## Version')===0)
  .filter(X => !X[1].match(re))
  .map(X => console.log(`${filename}:${X[0]+1} ${X[1]}`))

if(result.length>0)
  throw Error('Date not maintained');

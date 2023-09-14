const fs = require('fs');
const path = require('node:path');

const skip=[
  'node:process', 'node:path', 'node:fs', 'node:os',
  'assert', 'chai', 'chai-shallow-deep-equal', 'chai-sorted',
  'tree-kill', '@cucumber/cucumber'
]

let errors = 0;
checkDir('./lib/steps');
if(errors!=0)
  throw Error(`Found ${errors} error(s)`);
else
  console.log('no errors');


function oneFile(fn) {
  console.log('check',fn)
  let lines = fs.readFileSync(fn).toString().split('\n');
  let quotes = lines.map((X,I)=>[I+1,X]).filter(X=>X[1].indexOf('require(\"')!=-1);
  quotes.forEach(X=>console.log(`${fn}:${X[0]} use single quotes:`,X[1]))
  let errors = quotes.length;
  let r = lines.map((X,I)=>[I+1,X.match(/require\(\'(.*)\'\)/)])
    .filter(X=>X[1])
    .filter(X=>!skip.includes(X[1][1]))
    .map(X=>[X[0],X[1][0],X[1][1],X[1].index+1+'require(\''.length])
  if(r.length>0) {
    r.forEach(X => {
      const fp = path.join(path.dirname(fn),X[2])+'.js';
      if(!fs.existsSync(fp)) {
        console.log(`${fn}:${X[0]}:${X[3]}`,'missing',fp)
        errors++;
      }
    })
  }
  return errors;
}

function checkDir(dir) {
  const files = fs.readdirSync(dir);
  return files.map(F => {
    let fn = path.join(dir,F); 
    if(fs.lstatSync(fn).isDirectory()) return checkDir(fn);
    if(!F.endsWith('.js')) return;
    errors += oneFile(fn);
  })
}

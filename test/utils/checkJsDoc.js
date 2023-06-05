const { error } = require('console');
const fs = require('fs');
const path = require('node:path');

const dir = './lib/steps/';

let ff = fs.readdirSync(dir);
let r = ff.map(oneFile)
let errors = r.reduce((old,value) => old+=value, 0)
if(errors!=0)
  throw Error(`Found ${errors}`);
else
  console.log('no errors');

function oneFile(f) {
  let errors=0;
  if(f=='index.js') return errors;
  let fp = path.join(dir,f);
  console.log('check',fp)
  let s = String(fs.readFileSync(fp));
  if(s.match(/\@ignore/)) return 0;
  let rns = s.match(/\@namespace (.*?) /);
  if(!rns) {
    console.log("no namespace")
    errors++;
  }

  let re = /\/\*\*.*?\*\//gs;
  let r = s.matchAll(re);
  for(a of r) {
    if(!oneComment(fp,a[0],a.index))
      errors++;
  }
  return errors;
}

function oneComment(fp,s,index) {
  let rns = s.match(/\@namespace (.*?) /);
  if(rns) return true; // ignore namespace
  let rn = s.match(/\@name (.*?) /);
  let rx = s.match(/\@example (.*?) /);
  if(rn==null) {
    console.log("no name",index,s);
    return false;
  }
  if(rx==null) {
    console.log("no example",index,s);
    return false;
  }
  if(rn[1]!=rx[1]) {
    console.log("diff",index,rn[1],rx[1]);
    return false;
  }
  return true;
}

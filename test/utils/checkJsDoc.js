const fs = require('fs');
const path = require('node:path');

const dir = './lib/steps';

let errors = 0;
checkDir(dir);

if(errors!=0)
  throw Error(`Found ${errors} errors`);
else
  console.log('no errors');

function checkDir(dir) {
  const files = fs.readdirSync(dir);
  return files.map(F => {
    let fn = path.join(dir,F); 
    if(fs.lstatSync(fn).isDirectory()) return checkDir(fn);
    if(!F.endsWith('.js')) return;
    console.log('check',fn)
    errors += oneFile(fn);
  })
}

function oneFile(fp) {
  let errors=0;
  if(fp.endsWith('index.js')) return errors;
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

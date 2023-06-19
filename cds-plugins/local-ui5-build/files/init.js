#!/usr/bin/env node

const fs = require('node:fs');
const path = require('node:path');
const { argv, cwd, env } = require('process');

console.log("init.js",JSON.stringify(argv))
console.log("cwd",cwd())

let param;
let files=[];
argv.slice(2).forEach(arg => {
  console.log("arg",JSON.stringify(arg))
  if(arg[0]=='-') param=arg;
  else {
    if(param=='-f') files.push(arg);
  }
})
console.log("files", files)

files.forEach(file => {
  let fp = path.join(env.TARGET_DIR,file);
  let content = String(fs.readFileSync(fp));
  console.log("file",fp,content.length)

  let re1 = new RegExp('https\:\/\/.*sap-ui-core.js','g');
  content=content.replaceAll(re1,"resources/sap-ui-custom.js");

  let re2 = new RegExp('https\:\/\/.*test-resources\/sap\/ushell\/bootstrap\/sandbox.js','g');
  content=content.replaceAll(re2,"test-resources/sap/ushell/bootstrap/sandbox.js");

  fs.writeFileSync(fp, content);
  console.log('wrote',fp);

})

const fs = require('fs');

let errors = 0;

let _browser = './lib/browser.js';
try {
  _browser = require.resolve('cds-cucumber/lib/browser.js');
} catch(e) {}

let _controller = './lib/controller.js';
try {
  _controller = require.resolve('cds-cucumber/lib/controller.js');
} catch(e) {}

let browser = String(fs.readFileSync(_browser))
let browserLines = browser.split("\n");
let controller = String(fs.readFileSync(_controller))
let controllerLines = controller.split("\n");

let browserFunctions = {}
{
  let re = /(\w+)\((\w|\,|\s|\=|\')*?\)\ \{/g;
  let matches = browser.matchAll(re)
  for (const match of matches) {
    let name = match[1];
    let offset = match.index+3;
    browserFunctions[name]=offset;
  }
}

let controllerCalls = [];
{
  let re = /this\.call\([\"|\'](\w+)[\"|\']/g;
  for(let line=0; line<controllerLines.length; line++) {
    let matches = controllerLines[line].matchAll(re);
    for (const match of matches) {
      let name = match[1];
      controllerCalls.push({name,line});
    }
  }
}

for(let call of controllerCalls) {
  if(!browserFunctions[call.name]) {
    errors++;
    console.log("-->> missing",call.name)
    console.log(`${_controller}:${call.line+1} ${controllerLines[call.line]}`)
    browserLines
      .map((X,I)=>[I,X])
      .filter(X=>X[1].indexOf(call.name)!=-1)
      .map(X=>console.log(`--->> candidate:\n${_browser}:${X[0]+1} ${X[1]}`))
  }
}

process.exit(errors?1:0);

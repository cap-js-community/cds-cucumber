const path = require('node:path');
const httpGet = require('../../lib/httpGet');
const { argv } = require('process');

let arg = argv[2];
let url = arg;

if(!url.startsWith('http')) {
  let winPipePrefix = '\\\\.\\pipe\\';
  if(path.sep=='\\' && !url.startsWith(winPipePrefix))
    url = path.join(winPipePrefix,url).replace(':','');
  url = {
    socketPath: url,
    path:'/'
  }
}

(async function() {
  let loops=2*20;
  while(true) {
    try {
      await httpGet(url);
      console.log(`Server available: ${arg}`)
      break;
    } catch (e) {}
    console.log(`waiting ${loops} for ${arg} ...`)
    await sleep(500)
    loops--;
    if(loops===0) throw Error(`waitForServer ${arg} timeout`);
  }
})()

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

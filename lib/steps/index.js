const { Before, After, setDefaultTimeout } = require('@cucumber/cucumber');

const {env} = process;

const gTimeout = env.CDS_CUCUMBER_DEBUG=="1"?(60*60):60*10;
setDefaultTimeout(gTimeout * 1000);

Before(async function () {
  this.allProcesses = [];
})

After(async function () {
  if(this.controller) {
    if(env.SLOW_QUIT)
      await _sleep(1000*parseInt(env.SLOW_QUIT));
    await this.controller.quit();
    this.controller = undefined;
  }
  for(let process of this.allProcesses) {
    process.exitCode = -1;
    if(process.pid==0) continue;
    let kill = require('tree-kill');
    let signal = process.signal || 'SIGTERM';
    console.log('kill tree:', process.pid, signal);
    kill(process.pid, signal);
  }
  this.allProcesses=[];
})

function _sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

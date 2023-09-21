const { env } = require('process');
const fs = require('node:fs');

const pluginName = 'CDS Plugin Local SAP UI5 archive';

const cds = require('@sap/cds');

const tgz = env.SAPUI5_ARCHIVE_FILE;

if(!tgz)
  throw Error(`${pluginName}: Archive file not provided via environment variable SAPUI5_ARCHIVE_FILE`);

if(!tgz.endsWith('.tgz'))
  throw Error(`${pluginName}: File should end with "tgz": ${tgz}`);

if(!fs.existsSync(tgz))
  throw Error(`${pluginName}: File not found: ${tgz}`);

let files = undefined;
(async function () {
  const loadTGZ = require('./loadTGZ');
  console.log(`-->> loading SAP UI5 files from ${tgz} ...`);
  files = await loadTGZ(tgz);
  console.log(`-->> SAP UI5 files loaded: ${Object.keys(files).length}`);
})();

cds.on('bootstrap', async function (app) {
  if(!cds.env.preview) {
    let host = env.SAPUI5_FIORI_PREVIEW_HOST || '/';
    if(['','0'].includes(env.SAPUI5_FIORI_PREVIEW_HOST))
      host = undefined;
    if(host) {
      cds.env.preview = { ui5: { host } };
      console.log(pluginName,'set Fiori preview host:',JSON.stringify(host));
    }
  }
  app.get('/resources/*', serveFile);
  app.get('/test-resources/*', serveFile);
});


const mimetypes = require('./mimetypes');

async function serveFile(req,res) {
  const filename = req.url.substring(1);
  while(!files) await sleep(10);
  while(!files.done) await sleep(10);
  let sp = filename.split('.');
  let fileext = sp[sp.length -1];
  let contentType = mimetypes[fileext];
  if(!files[filename]) {
    res.status(404).send('Not found: '+filename);
  } else {
    if(contentType)
      res.setHeader('content-type', contentType);
    let chunks = files[filename];
    chunks.forEach(C => res.write(C))
    res.end();
  }
}

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

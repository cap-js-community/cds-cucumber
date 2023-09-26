const { env } = require('process');
const fs = require('node:fs');
const path = require('node:path');

const pluginName = 'CDS Plugin Local SAP UI5 archive';

const cds = require('@sap/cds');

if(env.SAPUI5_UNIX_DOMAIN_SOCKET) serveUDS()
else serveArchive();

function serveUDS() {
  const http = require('node:http');
  let uds = env.SAPUI5_UNIX_DOMAIN_SOCKET;
  const winPipePrefix = '\\\\.\\pipe\\';
  if(path.sep=='\\' && !uds.startsWith(winPipePrefix))
    uds = path.join(winPipePrefix,uds).replace(':','');

  cds.on('bootstrap', async function (app) {
    app.get('/resources/*', serveUdsFile);
    app.get('/test-resources/*', serveUdsFile);
  });

  async function serveUdsFile(inreq,inres) {
    return new Promise((resolve, reject) => {
      let socketPath = uds;
      let path = inreq.url;
      let req = http.get({path,socketPath}, (res) => {
        const { statusCode } = res;
        const headers = res.headers;
        const contentType = headers['content-type'];
        if(contentType)
          inres.setHeader('content-type', contentType);
        res.on('data', chunk => {
          inres.write(chunk);
        })
        res.on('end', () => {
          inres.end();
          resolve({statusCode,contentType})
        })
      })
  
      req.on('error', (e) => {
        reject(e);
      });
  
    })
  
  }
  
}

function serveArchive() {
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
  app.get('/resources/*', serveArchiveFile);
  app.get('/test-resources/*', serveArchiveFile);
});

const mimetypes = require('./mimetypes');

async function serveArchiveFile(req,res) {
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

}

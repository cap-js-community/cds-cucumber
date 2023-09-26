const fs = require('node:fs')
const path = require('node:path');
const { env } = require('node:process');

function getSAPUI5Version() {
  return env.SAP_UI5_VERSION || quessSAPUI5Version() || '1.118.0';
}

function locateSAPUI5Archive() {
  let filename = env.SAPUI5_ARCHIVE_FILENAME;
  if(!filename) {
    let version = getSAPUI5Version();
    const curdir = process.cwd();
    let files = [
      path.join(curdir,'sapui5-'+version+'.tgz'),
      path.join(curdir,'full-'+version+'.tgz'),
      path.join(__dirname,'..','..','tmp','sapui5','sapui5-'+version+'.tgz'),
      path.join(__dirname,'..','..','tmp','sapui5','full-'+version+'.tgz'),
      path.join(__dirname,'..','..','..','sapui5','sapui5-'+version+'.tgz'),
      path.join(__dirname,'..','..','..','sapui5','full-'+version+'.tgz'),
    ]
    let found = files.filter(file => fs.existsSync(file));
    filename=found[0];
  }
  return filename;
}

function serveDir(directory) {
  const HOSTNAME = env.HOSTNAME || 'localhost';
  const PORT = env.PORT || 8888;
  let targetDirectory = directory || env.SAPUI5_DIST_DIRECTORY;
  if(!targetDirectory) {
    let SAP_UI5_VERSION = getSAPUI5Version();
    const curdir = process.cwd();
    let dirs = [
      path.join(curdir),
      path.join(__dirname,'..','..','tmp','sapui5','full-'+SAP_UI5_VERSION,'dist'),
      path.join(__dirname,'..','..','..','sapui5','full-'+SAP_UI5_VERSION,'dist'),
    ]
    let found = dirs.filter(dir => fs.existsSync(path.join(dir,'manifest.json')));
    targetDirectory=found[0];
    if(!targetDirectory)
      throw 'Failed to find target directory';
  }
  if(!fs.existsSync(path.join(targetDirectory,'manifest.json')))
    throw `Directory '${targetDirectory}' does not contain a manifest.json file`;

  const express = require('express');

  var app = module.exports = express();

  process.chdir(targetDirectory)
  const curdir = process.cwd();
  console.log('Directory:',curdir)
  fs.readdirSync('.').forEach(ff => {
    const uri = `/${ff}`;
    const fn = path.join(curdir, ff);
    app.use(uri,express.static(fn))
  })

  app.get('*', (req, res) => {
    if(req.url.indexOf('..')!=-1) throw `Can not serve ${req.url}`;
    let s = `<h1>${process.cwd()}</h1>`+fs.readdirSync('.'+req.url).map(file => `<a href=${file}>${file}</a>`).join('<br>\n')
    res.send(s);
  });
  let uds = env.SAPUI5_UNIX_DOMAIN_SOCKET;
  if(uds)
    app.listen(uds, () => console.log(`Serving ${uds}`));
  else
    app.listen(PORT, () => console.log(`Serving http://${HOSTNAME}:${PORT}`));
}

const mimetypes = require('./mimetypes');

async function serveArchive(filename) {
  let files;

  const loadTGZ = require('./loadTGZ');
  console.log(`-->> Loading SAP UI5 files from ${filename} ...`);
  files = await loadTGZ(filename);
  console.log(`<<-- SAP UI5 files loaded: ${Object.keys(files).length}`);

  const express = require('express');

  var app = module.exports = express();

  const { env } = require('process');
  const HOSTNAME = env.HOSTNAME || 'localhost';
  const PORT = env.PORT || 8888;

  app.get('*', async (req, res) => {
    while(!files) await sleep(10);
    while(!files.done) await sleep(10);
    if(req.url == '/')
      res.send(Object.keys(files)
        .filter(F=>!F.endsWith('/'))
        .filter(F=>Array.isArray(files[F]))
        .map(F=>`<a href=${F}>${F}</a>`).join("<br>\n"));
    else {
      const fn = req.url.substring(1);
      if(fn==='$version') {
        const versoinFile = 'resources/sap-ui-version.json';
        const versionContent = files[versoinFile];
        if(!versionContent) {
          res.status(404).send('Not found: '+versoinFile);
        } else {
          const o = JSON.parse(versionContent.join(''));
          res.send(o.version);
        }
      } else if(!files[fn]) {
        res.status(404).send('Not found: '+fn);
      } else {
        let sp=fn.split(".")
        let ending = sp[sp.length-1];
        let contentType=mimetypes[ending];
        if(contentType)
          res.setHeader('content-type', contentType);
        else
          console.log("mimetype",fn,ending)
        let chunks = files[fn];
        chunks.forEach(C => res.write(C))
        res.end();
      }
    }
  });
  const winPipePrefix = '\\\\.\\pipe\\';
  let uds = env.SAPUI5_UNIX_DOMAIN_SOCKET;
  if(path.sep=='\\' && !uds.startsWith(winPipePrefix))
    uds = path.join(winPipePrefix,uds).replace(':','');
  if(uds)
    app.listen(uds, () => console.log(`Serving ${uds}`));
  else
    app.listen(PORT, () => console.log(`Serving http://${HOSTNAME}:${PORT}`));
}

function quessSAPUI5Version() {
  const path = require('node:path');
  const fs = require('node:fs')
  const fn = path.join(__dirname,'..','bin','.sapui5.version.sh');
  if(!fs.existsSync(fn)) return undefined;
  let lines = fs.readFileSync(fn).toString().replaceAll('\r','').split('\n');
  const re = /^\s*export\sSAP_UI5_VERSION/;
  let found = lines.filter(l => l.match(re)).map(s => s.split('=')[1].replaceAll('"',''))
  return found[found.length-1];
}

async function serve(source) {
  if(source) {
    if(source.endsWith('.tgz'))
      serveArchive(source);
    else
      serveDir(source);
  } else {
    let archive = locateSAPUI5Archive();
    if(archive) serveArchive(archive);
    else serveDir();
  }
}

if(require.main == module) {
  (async function() {
    let { argv } = process;
    await serve(argv[2]);
  })();
} else {
  module.exports = { serveDir, serveArchive }
}

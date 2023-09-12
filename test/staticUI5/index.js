
function serve() {
  const fs = require('node:fs')
  const path = require('node:path');
  const { env } = require('process');
  const HOSTNAME = env.HOSTNAME || 'localhost';
  const PORT = env.PORT || 8888;
  let SAPUI5_DIST_DIRECTORY = env.SAPUI5_DIST_DIRECTORY;
  if(!SAPUI5_DIST_DIRECTORY) {
    let SAP_UI5_VERSION = env.SAP_UI5_VERSION || quessSAPUI5Version() || '1.117.1';
    const curdir = process.cwd();
    let dirs = [
      path.join(curdir),
      path.join(__dirname,'..','..','tmp','sapui5','full-'+SAP_UI5_VERSION,'dist'),
      path.join(__dirname,'..','..','..','sapui5','full-'+SAP_UI5_VERSION,'dist'),
    ]
    let found = dirs.filter(dir => fs.existsSync(path.join(dir,'manifest.json')));
    SAPUI5_DIST_DIRECTORY=found[0];
    if(!SAPUI5_DIST_DIRECTORY)
      throw 'SAPUI5_DIST_DIRECTORY not set';
  }
  if(!fs.existsSync(path.join(SAPUI5_DIST_DIRECTORY,'manifest.json')))
    throw 'SAPUI5_DIST_DIRECTORY not valid';

  const express = require('express');

  var app = module.exports = express();

  process.chdir(SAPUI5_DIST_DIRECTORY)
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

  app.listen(PORT, () => console.log(`Serving http://${HOSTNAME}:${PORT}`));
}

function quessSAPUI5Version() {
  const path = require('node:path');
  const fs = require('node:fs')
  const fn = path.join(__dirname,'..','bin','.sapui5.version.sh');
  if(!fs.existsSync(fn)) return undefined;
  let lines = fs.readFileSync(fn).toString().split('\n');
  const re = /^\s*export\sSAP_UI5_VERSION/;
  let found = lines.filter(l => l.match(re)).map(s => s.split('=')[1].replaceAll('"',''))
  return found[found.length-1];
}

if(require.main == module) {
  serve();
} else {
  module.exports = serve;
}

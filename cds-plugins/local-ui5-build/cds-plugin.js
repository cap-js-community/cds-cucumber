const path = require('path');
const fs = require('fs');
const { env } = require('process');

const pluginName = 'CDS Plugin Local UI5 Build';

let dist = env.SAPUI5_DIST_DIRECTORY;
if(!dist)
  dist = path.join(__dirname, 'dist');
if(!fs.existsSync(dist))
  dist = path.join(process.cwd(), 'dist');

console.log(pluginName,'using:',dist);

const cds = require('@sap/cds')

const express = require('express');

cds.on('bootstrap', async (app) => {
  if(!cds.env.preview) {
    let host = env.SAPUI5_FIORI_PREVIEW_HOST || '/';
    if(['','0'].includes(env.SAPUI5_FIORI_PREVIEW_HOST))
      host = undefined;
    if(host) {
      cds.env.preview = { ui5: { host } };
      console.log(pluginName,'set Fiori preview host:',JSON.stringify(host));
    }
  }
  app.use('/resources', express.static(path.join(dist,'resources')))
  app.use('/test-resources', express.static(path.join(dist,'test-resources')))
})

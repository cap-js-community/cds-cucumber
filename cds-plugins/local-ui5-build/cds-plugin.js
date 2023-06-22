const path = require('path');
const fs = require('fs');
const { env } = require('process');

let dist = env.SAPUI5_DIST_DIRECTORY;
if(!dist)
  dist = path.join(__dirname, 'dist');
if(!fs.existsSync(dist))
  dist = path.join(process.cwd(), 'dist');

console.log("PLUGIN Local UI5 Build: ",dist);

const cds = require('@sap/cds')

const express = require('express');

cds.on('bootstrap', async (app) => {
  app.use('/resources', express.static(path.join(dist,'resources')))
  app.use('/test-resources', express.static(path.join(dist,'test-resources')))
})

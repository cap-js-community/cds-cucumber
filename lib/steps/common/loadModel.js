/** @ignore **/

const path = require('node:path');
const { env } = require('node:process');

async function loadModel(params={}) {
  try {
    let root = params.root || '';
    let directory = env.CDS_SERVICE_DIRECTORY || params.directory || '';
    let application = env.CDS_SERVICE_APPLICATION || params.application || '';
    let model = path.join(root, directory, application, '*');
    if(params.testOnly) return model;
  
    const cds = require ('@sap/cds');
    const csn = await cds.load(model,cds.env) .then (cds.minify) //> separate csn for _init_db
    if(!csn) throw Error("Failed to load the model");
    cds.model = cds.compile.for.nodejs(csn);
    if(!cds.model) throw Error("Failed to compile the model");
  } catch(e) {
    console.log(e)
    throw e
  }
}

module.exports = loadModel;

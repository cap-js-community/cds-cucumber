/** @namespace MTX **/

const { Given } = require('@cucumber/cucumber');

function infoProcess(process) {
  if(process.pid===0)
    console.log(`Connected to process '${process.params.application}'`);
  else
    console.log(`Started process '${process.params.application}' with pid ${process.pid}`);
}

async function GetDeploymentService(mtxProcess, username) {
  if(!mtxProcess)
    throw Error('MTX sidecar not started');

  let deploymentService = mtxProcess.deploymentService[username];
  if(deploymentService)
    return deploymentService;

  const cds = require ('@sap/cds');

  const deploymentServiceModel = require.resolve('@sap/cds-mtxs/srv/deployment-service.cds');
  const csn = await cds.compile([deploymentServiceModel]);
  const deploymentServiceName = 'cds.xt.DeploymentService';
  const deploymentServiceURI = csn.definitions[deploymentServiceName]['@path'];

  let credentials = { url: `http://${mtxProcess.hostname}:${mtxProcess.port}${deploymentServiceURI}` };

  const password = '';
  if(username)
    Object.assign(credentials, { username, password, authentication: "BasicAuthentication"});

  const serviceName = `${deploymentServiceName}#${username}@${mtxProcess.hostname}:${mtxProcess.port}`;
  const options = {
    kind: 'rest',
    credentials,
    model:[deploymentServiceModel]
  };
  deploymentService = await cds.connect.to(serviceName, options);
  mtxProcess.deploymentService[username] = deploymentService;
  return deploymentService;
}

Given('we have started MTX service', async function() {
  const startProcess = require('../startProcess');
  this.mtxProcess = await startProcess({application:'mtx/sidecar'});
  this.mtxProcess.deploymentService = {};
  this.allProcesses.push(this.mtxProcess);
  infoProcess(this.mtxProcess);
})

Given('we subscribe tenant {string} with user {string}', async function(tenant, username) {
  let deploymentService = await GetDeploymentService(this.mtxProcess, username);
  await deploymentService.subscribe(tenant);
})

Given('we unsubscribe tenant {string} with user {string}', async function(tenant, username) {
  let deploymentService = await GetDeploymentService(this.mtxProcess, username);
  await deploymentService.unsubscribe(tenant);
})

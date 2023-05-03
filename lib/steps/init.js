const { Given } = require('@cucumber/cucumber');

const Controller = require('../controller');

const {env} = process;

function infoProcess(process, application) {
  if(process.pid===0)
    console.log(`Connected to application '${application}'`);
  else
    console.log(`Started application '${application}' with pid ${process.pid}`);
}

Given('we have started application {string}', async function(application) {
  const startProcess = require('../startProcess');
  this.process = await startProcess(application);
  this.allProcesses.push(this.process);
  infoProcess(this.process, application);
})

Given('we have started application {string} in path {string}', async function(application, path) {
  const startProcess = require('../startProcess');
  this.process = await startProcess(application, path);
  this.allProcesses.push(this.process);
  infoProcess(this.process, application);
})

Given('we have started the application', async function() {
  const startProcess = require('../startProcess');
  let stack = env.TEST_STACK || 'node';
  let dir = env.TEST_SERVICE_DIR || '.';
  this.process = await startProcess(stack, dir);
  this.allProcesses.push(this.process);
  infoProcess(this.process, stack);
})

Given('we have started the java application', async function() {
  const startProcess = require('../startProcess');
  this.process = await startProcess('java');
  this.allProcesses.push(this.process);
  infoProcess(this.process, 'java');
})

Given('we have started the node application', async function() {
  const startProcess = require('../startProcess');
  this.process = await startProcess('node');
  this.allProcesses.push(this.process);
  infoProcess(this.process, 'node');
})

Given('we have started the java application in path {string}', async function(path) {
  const startProcess = require('../startProcess');
  this.process = await startProcess('java', path);
  this.allProcesses.push(this.process);
  infoProcess(this.process, 'java');
})

Given('we have inspected url {string}', async function(url) {
  let { username, password } = getCredentials();
  let info = await inspectUrl(this.process, url, username, password);
  console.log("URL info",url,info);//TODO remove
})

Given('we have set language to {string}', async function(language) {
  this.language = language;
})

Given('we have opened the url {string}', async function(url) {
  this.controller = await openUrl(this.controller, this.process, url, {language: this.language} );
})

Given('we have opened the url {string} with user {string}', async function(url, username) {
  this.controller = await openUrl(this.controller, this.process, url, {username, language: this.language} );
})

Given('we have opened the url {string} with user {string} and password {string}', async function(url, username, password) {
  this.controller = await openUrl(this.controller, this.process, url, {username, password, language: this.language} );
})

Given('we login with user {string} using path {string}', async function( user, path ) {
  await this.controller.authenticate(path, user);
})

Given('we login with user {string} and password {string} using path {string}', async function( user, password, path ) {
  await this.controller.authenticate(path, user, password);
})

When('we navigate to url {string}', async function(url) {
  url = buildUrl(this.process, url);
  await this.controller.openUrl(url);
  if(!await this.controller.initializeLibrary())
    throw Error('Failed to initialize the library!');
  await this.controller.waitToLoad(5);
})

When('we quit', async function() {
  if(this.controller) {
    await this.controller.quit();
    this.controller=undefined;
  }
})

When('we logout', async function() {
  await this.controller.pressLogOutButton();
  await this.controller.waitToLoad();
  await this.controller.pressButtonInDialog('OK', 'Sign Out');
  if(!await this.controller.initializeLibrary())
    throw Error('Failed to initialize the library!');
})

function buildUrl(process, url) {
  if(url && url.startsWith('http')) return url;
  let hostname=env.hostname || 'localhost';
  let port=env.PORT?parseInt(env.PORT):(process?process.port:4004);
  if(!url)
    return `http://${hostname}:${port}`;
  if(!url.startsWith('http')) {
    if(!url.startsWith('/')) url='/'+url;
    url=`http://${hostname}:${port}${url}`;
  }
  return replaceUrl(url);
}

async function openUrl(controller, process, url, options) {
  let { username, password } = getCredentials(options);
  url = buildUrl(process, url);
  let info = await inspectUrl(this.process, url, username, password);
  const isUI5url = info.ui5bootstrap;

  if(controller && (!info.protected || controller.username===username)) {
    await controller.openUrl(url, options.language);
    if(isUI5url) {
      if(!await controller.initializeLibrary())
        throw Error('Failed to initialize the library!');
      await controller.waitBlockers();
    }
    return controller;
  }
  if(controller) { // terminate current browser
    await controller.quit();
    controller = undefined;
  }
  try {
    controller = new Controller();
    await controller.initDriver();
    let protectedOdataEndpoint;
    if(isUI5url) {
      let { findProtectedEndpoint } = require('../inspectWebPage');
      protectedOdataEndpoint = await findProtectedEndpoint(url);
      if(!username && protectedOdataEndpoint)
        throw Error(`URl ${url} requires username for endpoint ${protectedOdataEndpoint.href}`);
    }
    let isShell = protectedOdataEndpoint=="shell";
    if(username && isUI5url) {
      if(protectedOdataEndpoint && protectedOdataEndpoint!=='shell') {
        controller.username = username;
        let credUrl = new URL(protectedOdataEndpoint);
        credUrl.username = username;
        credUrl.password = password;
        { // validate
          const httpGet = require('../httpGet');
          let res = await httpGet(credUrl);
          if(res.statusCode!=200)
            throw Error(`http get '${credUrl.toString()}' failed with ${res.statusCode}`);
        }
        await controller.openUrl(credUrl, options.language);
      }
    }
    await controller.openUrl(url, options.language);
    if(isUI5url) {
      if(!await controller.initializeLibrary())
        throw Error('Failed to initialize the library!');
      await controller.waitBlockers();
    }
    if(isShell) {
      // find odata endpoint returning 401 Unauthorized Error
      let { inspectInbounds } = require('../inspectWebPage');
      let inbounds = await controller.getInbounds();
      let urlBase = buildUrl(process);
      let res = await inspectInbounds(urlBase,inbounds);
      if(res['401']) // use first protected endpoint to authenticate
        await controller.authenticate(res['401'][0], username, password);
      else
        throw Error("Protected data source not found");
    }
  } catch (e) {
    if(controller) controller.quit();
    throw e;
  }
  return controller;
}

async function inspectUrl(process, url, username, password) {
  url = buildUrl(process, url);
  const httpGet = require('../httpGet')
  let {statusCode, content} = await httpGet(url);
  const protected = statusCode===401; // not authorized
  let protectedStatusCode;
  if(protected && username) {
    url = new URL(url);
    url.username = username;
    url.password = password;
    ({content, statusCode: protectedStatusCode} = await httpGet(url));
  }
  let ui5bootstrap;
  let fioriPreview;
  if(statusCode==200 || protectedStatusCode==200) {
    ui5bootstrap=!!content.match('sap\-ui\-bootstrap');
    fioriPreview=!!content.match('Fiori preview');
  }
  return {
    statusCode,
    protectedStatusCode,
    protected,
    fioriPreview,
    ui5bootstrap
  }
}

function getCredentials(options={}) {
  return {
    username: options.username || env.TEST_USER,
    password: options.password || env.TEST_PASSWORD
  }
}

function replaceUrl(url) {
  if(env.REPLACE_PAGE) {
    if(env.REPLACE_PAGE === url) {
      if(env.REPLACE_PREFIX) {
        url = env.REPLACE_PREFIX + url;
        console.log("REPLACED: "+url)
      } else if(env.SAP_UI5_VERSION) {
        url = env.SAP_UI5_VERSION + '-' + url;
        console.log("REPLACED: "+url)
      }
    } else if(url.indexOf(env.REPLACE_PAGE)!=-1) {
      let prefix = env.REPLACE_PREFIX || env.SAP_UI5_VERSION + '-';
      url = url.replace(env.REPLACE_PAGE, prefix+env.REPLACE_PAGE);
      console.log("REPLACED: "+url)
    }
  }
  return url;
}

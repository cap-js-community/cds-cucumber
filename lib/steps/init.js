/** @namespace Initialization **/

const { Given, When } = require('@cucumber/cucumber');

const Controller = require('../controller');

const {env} = process;

function infoProcess(process, application) {
  if(process.pid===0)
    console.log(`Connected to application '${application}'`);
  else
    console.log(`Started application '${application}' with pid ${process.pid}`);
}

/**
* @memberof Initialization
* @name Given we have started the application
* @description Starts the cds service.
* @example Given we have started application
*/
Given('we have started the application', async function() {
  const startProcess = require('../startProcess');
  let stack = env.CDS_STACK || 'node';
  let dir = env.CDS_SERVICE_DIR || '.';
  this.process = await startProcess(stack, dir);
  this.allProcesses.push(this.process);
  infoProcess(this.process, stack);
})

/**
* @memberof Initialization
* @name Given we have started application {string}
* @param {string} application name to start
* @description Starts the cds service of the specified application.
    The application name is passed as a parameter to the cds command.
* @example Given we have started application "fiori"
*/
Given('we have started application {string}', async function(application) {
  const startProcess = require('../startProcess');
  this.process = await startProcess(application);
  this.allProcesses.push(this.process);
  infoProcess(this.process, application);
})

/**
* @memberof Initialization
* @name Given we have started application {string} in path {string}
* @param {string} application name of the application to start
* @param {string} path directory where the application is located
* @description Starts the cds service of the specified application.
    The application name is passed as a parameter to the cds command.
    The cds command is started with the specified path as current directory.
* @example Given we have started application "fiori" in path "directory"
*/
Given('we have started application {string} in path {string}', async function(application, path) {
  const startProcess = require('../startProcess');
  this.process = await startProcess(application, path);
  this.allProcesses.push(this.process);
  infoProcess(this.process, application);
})

/**
* @memberof Initialization
* @name Given we have started the java application
* @description Starts the java cds service
* @example Given we have started the java application
*/
Given('we have started the java application', async function() {
  const startProcess = require('../startProcess');
  this.process = await startProcess('java');
  this.allProcesses.push(this.process);
  infoProcess(this.process, 'java');
})

/**
* @memberof Initialization
* @name Given we have started the node application
* @description Starts the node cds service using the following command: "npx cds run"
* @example Given we have started node application
*/
Given('we have started the node application', async function() {
  const startProcess = require('../startProcess');
  this.process = await startProcess('node');
  this.allProcesses.push(this.process);
  infoProcess(this.process, 'node');
})

/**
* @memberof Initialization
* @name Given we have started the java application in path {string}
* @description Starts the java cds service using the following command: "mvn clean spring-boot:run"
* @param {string} path directory where the application is located
* @example Given we have started java application
*/
Given('we have started the java application in path {string}', async function(path) {
  const startProcess = require('../startProcess');
  this.process = await startProcess('java', path);
  this.allProcesses.push(this.process);
  infoProcess(this.process, 'java');
})

// internal
Given('we have inspected url {string}', async function(url) {
  let { username, password } = getCredentials();
  let info = await inspectUrl(this.process, url, username, password);
  console.log("URL info",url,info);//TODO remove
})

/**
* @memberof Initialization
* @name Given we have set language to {string}
* @description Sets the used UI language
* @param {string} language language to use
* @example Given we have set language to "DE"
*/
Given('we have set language to {string}', async function(language) {
  this.language = language;
})

/**
* @memberof Initialization
* @name Given we have opened the url {string}
* @param {string} url url to open
* @description Opens the specified url in the browser
* @example Given we have opened the url "/"
*/
Given('we have opened the url {string}', async function(url) {
  this.controller = await openUrl(this.controller, this.process, url, {language: this.language} );
})

/**
* @memberof Initialization
* @name Given we have opened the url {string} with user {string}
* @param {string} url url to open
* @param {string} username name of the user
* @description Opens the specified url in the browser and uses the specified username to login
* @example Given we have opened the url "/" with user "alice"
*/
Given('we have opened the url {string} with user {string}', async function(url, username) {
  this.controller = await openUrl(this.controller, this.process, url, {username, language: this.language} );
})

/**
* @memberof Initialization
* @name Given we have opened the url {string} with user {string} and password {string}
* @param {string} url url to open
* @param {string} username name of the user to authenticate with
* @param {string} password password to use for authentication
* @description Opens the specified url in the browser and uses the specified username and password to login
* @example Given we have opened the url "/" with user "alice" and password "admin"
*/
Given('we have opened the url {string} with user {string} and password {string}', async function(url, username, password) {
  this.controller = await openUrl(this.controller, this.process, url, {username, password, language: this.language} );
})

/**
* @memberof Initialization
* @name Given we login with user {string} using path {string}
* @param {string} user url to open
* @param {string} path endpoing path to use for authentication
* @description Opens the specified url in the browser and uses the specified username to login
* @example Given we login with user "alice" using path "/"
*/
Given('we login with user {string} using path {string}', async function( user, path ) {
  await this.controller.authenticate(path, user);
})

/**
* @memberof Initialization
* @name Given we login with user {string} and password {string} using path {string}
* @param {string} username name of the user to authenticate with
* @param {string} password password to use for authentication
* @param {string} path endpoing path to use for authentication
* @description Opens the specified url in the browser and uses the specified username to login
* @example Given we login with user "alice" using path "/"
*/
Given('we login with user {string} and password {string} using path {string}', async function( username, password, path ) {
  await this.controller.authenticate(path, username, password);
})

/**
* @memberof Initialization
* @name Given we navigate to url {string}
* @param {string} url url to open
* @description Points the already opened browser to the specified url
* @example When we navigate to url "/"
*/
When('we navigate to url {string}', async function(url) {
  url = buildUrl(this.process, url);
  await this.controller.openUrl(url);
  if(!await this.controller.initializeLibrary())
    throw Error('Failed to initialize the library!');
  await this.controller.waitBlockers(200);
})

/**
* @memberof Initialization
* @name When we quit
* @description Closes the current browser
* @example When we quit
*/
When('we quit', async function() {
  if(this.controller) {
    await this.controller.quit();
    this.controller=undefined;
  }
})

// internal
When('we logout', async function() {
  await this.controller.pressLogOutButton();
  await this.controller.waitToLoad();
  await this.controller.pressButtonInDialog('OK', 'Sign Out');
  if(!await this.controller.initializeLibrary())
    throw Error('Failed to initialize the library!');
})

function buildUrl(process, url) {
  if(url && url.startsWith('http')) return url;
  let hostname=env.REMOTE_HOSTNAME || 'localhost';
  let port=env.REMOTE_PORT?parseInt(env.REMOTE_PORT):(process?process.port:4004);
  if(!url)
    return `http://${hostname}:${port}`;
  if(!url.startsWith('http')) {
    if(!url.startsWith('/')) url='/'+url;
    url=`http://${hostname}:${port}${url}`;
  }
  return replaceUrl(url);
}

async function openUrl(controller, process, url, options) {
  let waitBlockersIter = 500;
  if(options.language)
    waitBlockersIter *= 50;
  let { username, password } = getCredentials(options);
  url = buildUrl(process, url);
  let info = await inspectUrl(this.process, url, username, password);
  const isUI5url = info.ui5bootstrap;

  if(controller && (!info.protected || controller.username===username)) {
    await controller.openUrl(url, options.language);
    if(isUI5url) {
      if(!await controller.initializeLibrary())
        throw Error('Failed to initialize the library!');
      await controller.waitBlockers(waitBlockersIter);
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
      await controller.waitBlockers(waitBlockersIter);
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
  const isProtected = statusCode===401; // not authorized
  let protectedStatusCode;
  if(isProtected && username) {
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
    protected: isProtected,
    fioriPreview,
    ui5bootstrap
  }
}

function getCredentials(options={}) {
  return {
    username: options.username || env.CDS_USERNAME,
    password: options.password || env.CDS_PASSWORD
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

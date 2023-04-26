const assert = require('assert');
const chai = require('chai');
chai.use(require('chai-shallow-deep-equal'));

const { Given, Before, After, setDefaultTimeout, When, Then } = require('@cucumber/cucumber');

const Controller = require('../controller');

const {env} = process;

const gTimeout = env.CDS_BDD_DEBUG=="1"?(30*60):60*3;
setDefaultTimeout(gTimeout * 1000);

Before(async function () {
  let fs = require('fs');
  let os = require('os');
  let path = require('path');
  const registryFile = path.join(os.homedir(),".cds-services.json");
  if(fs.existsSync(registryFile)) {
    console.log("delete",registryFile)
    fs.unlinkSync(registryFile);
  }
  this.allProcesses = [];
})

After(async function () {
  if(this.controller) {
    if(env.SLOWQUIT)
      await _sleep(1000*parseInt(env.SLOWQUIT));
    await this.controller.quit();
    this.controller = undefined;
  }
  for(let process of this.allProcesses) {
    process.exitCode = -1;
    if(process.pid==0) continue;
    let kill = require('tree-kill');
    let signal = process.signal || 'SIGTERM';
    console.log('kill tree:', process.pid, signal);
    kill(process.pid, signal);
  }
  this.allProcesses=[];
})

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

When('we click on first Fiori preview page', async function() {
  await this.controller.clickOnElementWithClass('preview');
  await this.controller.waitToLoad();
  if(!await this.controller.initializeLibrary())
    throw Error('Failed to initialize the library!');
  await this.controller.waitBlockers();
})

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

Given('table {string} has {int} records', async function( tableName, expectedRowCount ) {
  let totalRowCount = await this.controller.extractTableRowsTotalCount(tableName);
  assert.equal(totalRowCount, expectedRowCount)
})

When('we navigate back', async function() {
  await this.controller.pressGoBackButton();
  await this.controller.waitToLoad();
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

Given('table {string} has {int} visible records', async function( tableName, expectedRowCount ) {
  let content = await this.controller.extractTableContent(tableName);
  assert.equal(content.length, expectedRowCount)
})

When('save the result', async function() {
  this.saved=this.result;
})

When('we get the title of the page', async function() {
  this.result = await this.controller.getTitle();
})

When('we list all tiles', async function() {
  this.result = await this.controller.getTiles();
})

When('we select tile {string}', async function(tile) {
  await this.controller.pressTile(tile);
  await this.controller.waitToLoad();
})

When('we click on text {string}', async function( text ) {
  this.result = await this.controller.clickOnText(text);
  await this.controller.waitToLoad();
})

When('we click on link {string}', async function( text ) {
  this.result = await this.controller.clickOnLink(text);
  await this.controller.waitToLoad();
})

When('we click on object identifier {string}', async function( text ) {
  this.result = await this.controller.clickOnObjectIdentifier(text);
  await this.controller.waitToLoad();
})

When('we tap on text {string}', async function( text ) {
  this.result = await this.controller.tapOnText(text);
  await this.controller.waitToLoad();
})

When('we tap on link {string}', async function( text ) {
  this.result = await this.controller.tapOnLink(text);
  await this.controller.waitToLoad();
})

When('we tap on object identifier {string}', async function( text ) {
  this.result = await this.controller.tapOnObjectIdentifier(text);
  await this.controller.waitToLoad();
})

When('we read the content', async function() {
  this.result = await this.controller.extractCurrentPageContent();
})

When('we read the content of the page', async function() {
  this.result = await this.controller.extractObjectPageContent();
})

When('we read the content of the page with bindings', async function() {
  this.result = await this.controller.extractObjectPageContentWithBindingInfo();
})

When('we read the content of the rows in the table', async function() {
  this.result = await this.controller.extractTableRows();
})

When('we read the content of the table with bindings', async function() {
  this.result = await this.controller.extractTableContentWithBindingInfo();
})

When('we perform basic search for {string}', async function( text ) {
  await this.controller.performBasicSearch(text);
  await this.controller.waitEvents();
})

When('we enter in the search field {string}', async function( text ) {
  await this.controller.editSearchField(text);
  await this.controller.waitEvents();
})

When('we change field {string} to {string}', async function( field, text ) {
  await this.controller.editField(field,text);
  await this.controller.waitToLoad();
})

When('we modify field {string} to {string}', async function( field, text ) {
  if(false==await this.controller.modifyField(field,text)) {
    await this.controller.waitEvents();
    await this.controller.selectItemInValueHelp(field, text);
    await this.controller.waitEvents();
  }
})

When('we change the header field {string} to {string}', async function( field, text ) {
  await this.controller.editHeaderField(field,text);
  await this.controller.waitToLoad();
})

When('we change the identification field {string} to {string}', async function( field, text ) {
  await this.controller.editIdentificationField(field,text);
  await this.controller.waitToLoad();
})

When('we change the field {string} in group {string} to {string}', async function( field, group, text ) {
  await this.controller.editGroupField(group,field,text);
  await this.controller.waitToLoad();
})

When('we change the field {string} in the last row of table in section {string} to {string}', async function( field, section, text ) {
  await this.controller.editFieldInLastRowOfLineItemTableInSection(section, field, text);
  await this.controller.waitToLoad();
})

When('we decide to save the draft', async function() {
  await this.controller.chooseItemInListDialog('Warning','Create');
  await this.controller.waitToLoad();
})

When('we decide to keep the draft', async function() {
  await this.controller.chooseItemInListDialog('Warning','Keep Draft');
  await this.controller.waitToLoad();
})

When('we decide to discard the draft', async function() {
  await this.controller.chooseItemInListDialog('Warning','Discard Draft');
  await this.controller.waitToLoad();
})

When('switch to active version', async function() {
  await this.controller.switchToActiveVersion();
  await this.controller.waitToLoad();
})

When('switch to draft version', async function() {
  await this.controller.switchToDraftVersion();
  await this.controller.waitToLoad();
})

When('we edit current object', async function( ) {
  await this.controller.pressStandardActionButtonInObjectPageHeader('Edit');
  await this.controller.waitToLoad();
})

When('we create new item', async function() {
  await this.controller.pressButtonForLineItemTable('Create');
  await this.controller.waitToLoad();
})

When('we select all rows in table {string}', async function( tableName ) {
  await this.controller.selectAllRowsLineItemTable(tableName);
  await this.controller.waitEvents();
})

When('we tap on row {int} in table {string}', async function( row, tableName ) {
  await this.controller.tapOnRowInLineItemTable(tableName, row);
  await this.controller.waitEvents();
})

When('we select row {int} in table {string}', async function( row, tableName ) {
  await this.controller.selectRowInLineItemTable(tableName, row);
  await this.controller.waitEvents();
})

When('we select rows in table {string} having {string} equal to {string}', async function( tableName, columnName, value ) {
  await this.controller.selectRowsInLineItemTableHaving(tableName, columnName, value);
  await this.controller.waitEvents();
})

When('we create new item for table {string}', async function( tableName ) {
  await this.controller.pressButtonForLineItemTable('Create', tableName);
  await this.controller.waitToLoad();
})

When('we delete selected rows in table {string}', async function( tableName ) {
  await this.controller.pressButtonForLineItemTable('Delete', tableName);
  await this.controller.waitEvents();
})

When('we create new item for table in section {string}', async function( sectionName ) {
  await this.controller.pressButtonForLineItemTableInSection('Create', sectionName);
  await this.controller.waitToLoad();
})

When('we apply the changes', async function() {
  await this.controller.applyChanges();
  await this.controller.waitToLoad();
})

When('we press button {string} in active dialog', async function( label ) {
  await this.controller.pressButtonInActiveDialog(label);
  await this.controller.waitToLoad();
})

When('we press button {string}', async function( label ) {
  await this.controller.pressButton(label);
  await this.controller.waitToLoad();
})

When('we filter by {string} equal to {string} having Id {string}', async function( field, text, id ) {
  await this.controller.addConditionEqualInFilterField(field,[id,text]);
  await this.controller.waitEvents();
})

When('we filter by {string} equal to {string}', async function( field, text ) {
  await this.controller.addConditionEqualInFilterField(field,text);
  await this.controller.waitEvents();
})

When('we filter by {string} greater than {int}', async function( field, value ) {
  await this.controller.addConditionGreaterInFilterField(field,value);
  await this.controller.waitEvents();
})

When('we apply the search filter', async function( ) {
  await this.controller.applySearchFilter();
  await this.controller.waitToLoad();
})

When('we create draft', async function() {
  await this.controller.createDraft();
  await this.controller.waitToLoad();
})

When('we save the draft', async function() {
  await this.controller.saveDraft();
  await this.controller.waitToLoad();
})

When('we discard draft', async function() {
  await this.controller.discardDraft();
  await this.controller.waitEvents();
  await this.controller.confirmDiscardDraftOnObjectPage();
  await this.controller.waitToLoad();
})

When('we delete the object instance', async function() {
  await this.controller.deleteObjectInstance();
  await this.controller.waitEvents();
})

When('we confirm the deletion', async function() {
  await this.controller.pressButtonInDialog('Delete', 'Delete');
  await this.controller.waitToLoad();
})

When('we open value help for field {string}', async function( field ) {
  await this.controller.openValueHelpDialogForField(field);
  await this.controller.waitEvents();
  await this.controller.waitToLoad();
})

When('we open value help for object field {string}', async function( field ) {
  await this.controller.openValueHelpDialogForObjectField(field);
  await this.controller.waitEvents();
  await this.controller.waitToLoad();
})

When('we open value help for filter field {string}', async function( field ) {
  await this.controller.openValueHelpDialogForFilterField(field);
  await this.controller.waitEvents();
  await this.controller.waitToLoad();
})

When('we close value help for field {string}', async function( field ) {
  await this.controller.openValueHelpDialogForField(field);
  await this.controller.waitEvents();
})

When('we close value help for object field {string}', async function( field ) {
  await this.controller.openValueHelpDialogForObjectField(field);
  await this.controller.waitEvents();
})

When('we close value help for filter field {string}', async function( field ) {
  await this.controller.openValueHelpDialogForFilterField(field);
  await this.controller.waitEvents();
})

When('we select draft editing status {string}', async function( text ) {
  await this.controller.selectItemInValueHelp('Editing Status', text);
  await this.controller.waitEvents();
})

When('we confirm value help dialog', async function( ) {
  await this.controller.pressOkInValueHelpDialog();
  await this.controller.waitEvents();
})

When('we enter in the prompt {string}', async function( value ) {
  await this.controller.enterValueInPrompt(value);
  await this.controller.waitEvents();
})

When('we select first row in value help dialog having field {string} equal to {string}', async function( columnName, searchText ) {
  await this.controller.selectFirstMatchingRowInValueHelpDialog(columnName, searchText);
  await this.controller.waitEvents();
})

When('we select one row in value help dialog having field {string} equal to {string}', async function( columnName, searchText ) {
  await this.controller.selectOneRowInValueHelpDialog(columnName, searchText);
  await this.controller.waitEvents();
})

When('we select additional row in value help dialog having field {string} equal to {string}', async function( columnName, searchText ) {
  await this.controller.selectAdditionalRowInValueHelpDialog(columnName, searchText);
  await this.controller.waitEvents();
})

When('we select one suggestion in value help dialog for field {string} equal to {string}', async function( columnName, searchText ) {
  await this.controller.selectItemInFieldValueHelp(columnName, searchText);
  await this.controller.waitEvents();
})

When('we show the adapt filter dialog', async function() {
  await this.controller.firePressOnAdaptFilterButton();
  await this.controller.waitToLoad();
})

When('we select field {string} in adapt filter', async function( columnName ) {
  await this.controller.selectFieldInAdaptFilterDialog(columnName);
  await this.controller.waitEvents();
})

When('we select all fields in adapt filter', async function() {
  await this.controller.selectAllFieldsInAdaptFilterDialog();
  await this.controller.waitEvents();
})

When('we apply the adapt filter', async function( ) {
  await this.controller.pressOkInAdaptFilterDialog();
  await this.controller.waitToLoad();
})

When('we perform object action {string}', async function( label ) {
  await this.controller.pressObjectPageActionBarButton(label);
  await this.controller.waitEvents();
})

When('we select day {string}', async function( day ) {
  await this.controller.selectDayInVisibleCalendar(day);
  await this.controller.waitEvents();
})

When('we select year {string}', async function( day ) {
  await this.controller.performActionOnVisibleCalendar('year')
  await this.controller.waitEvents();
  await this.controller.selectYearInVisibleCalendar(day);
  await this.controller.waitEvents();
})

When('we select month {string}', async function( month ) {
  await this.controller.performActionOnVisibleCalendar('month')
  await this.controller.waitEvents();
  await this.controller.selectMonthInVisibleCalendar(month);
  await this.controller.waitEvents();
})

When('we roll calendar to {string}', async function( action ) {
  await this.controller.rollVisibleCalendar(action);
  await this.controller.waitEvents();
})

Then('we expect the result to match array ignoring element order', async function( expected ) {
  assert.deepEqual(this.result.sort(), JSON.parse(expected).sort());
})

Then('we expect the result to contain the following details', async function( expected ) {
  chai.expect(this.result).to.shallowDeepEqual(JSON.parse(expected));
})

Then('we expect the result to match the saved one', async function() {
  chai.expect(this.result).to.shallowDeepEqual(this.saved);
})

Then('we expect the result to be {string}', async function( text ) {
  assert.equal(this.result, text);
})

Then('sleep for {int} seconds', async function( seconds ) {
  await this.controller._sleep(1000*seconds);
})

Then('we expect the next step to fail', async function( ) {
  await this.controller.setExpectToFail();
})

function findFieldInObjectStructure(content, fieldName) {
  if(typeof content === 'object') {
    for(let key in content) {
      let value = content[key];
      if(typeof value!=='object'){
        if(key==fieldName)
          return value;
        continue;
      }
      let found = findFieldInObjectStructure(value, fieldName);
      if(found && typeof found!=='object') return found;
    }
  }
  return undefined;
}

When('we expect field {string} to be {string}', async function( fieldName, expected ) {
  let content = await this.controller.extractCurrentPageContent();
  let found = findFieldInObjectStructure(content, fieldName);
  if(!found)
    throw Error(`Field ${fieldName} not found, fields: ${Object.keys(content)}`);
  found = found.replaceAll(' ',' '); // replace non-breaking space
  assert.equal(found, expected)
})

Then('we expect table {string} to contain the following rows', async function( tableName, expected ) {
  let content = await this.controller.extractTableContent(tableName);
  chai.expect(content).to.shallowDeepEqual(JSON.parse(expected));
})

Then('we expect table {string} to contain records', async function( tableName, expected ) {
  let content = await this.controller.extractTableContent(tableName);
  expected=JSON.parse(expected);
  let missingRecords = [];
  expected.forEach(E => {
    let found = false;
    content.forEach(R => {
      try {
        chai.expect(R).to.shallowDeepEqual(E);
        found=true;
      } catch (e) {}
    })
    if(!found) missingRecords.push(E);
  })
  assert.ok(missingRecords.length==0,`Records not found: ${JSON.stringify(missingRecords)}`)
})

Then('we expect table {string} not to contain records', async function( tableName, expected ) {
  let content = await this.controller.extractTableContent(tableName);
  expected=JSON.parse(expected);
  let foundRecords = [];
  expected.forEach(E => {
    let found = false;
    content.forEach(R => {
      try {
        chai.expect(R).to.shallowDeepEqual(E);
        found=true;
      } catch (e) {}
    })
    if(found) foundRecords.push(E);
  })
  assert.ok(foundRecords.length==0,`Records found: ${JSON.stringify(foundRecords)}`)
})

Then('we expect table {string} to contain record', async function( tableName, expected ) {
  let content = await this.controller.extractTableContent(tableName);
  expected=JSON.parse(expected);
  let found = false;
  content.forEach(R => {
    try {
      chai.expect(R).to.shallowDeepEqual(expected);
      found=true;
    } catch (e) {}
  })
  assert.ok(found,`Record not found - expected:${JSON.stringify(expected)} in ${JSON.stringify(content)}`)
})

Then('we expect table {string} not to contain record', async function( tableName, unexpected ) {
  let content = await this.controller.extractTableContent(tableName);
  unexpected=JSON.parse(unexpected);
  let found = false;
  content.forEach(R => {
    try {
      chai.expect(R).to.shallowDeepEqual(unexpected);
      found=true;
    } catch (e) {}
  })
  assert.ok(!found,`Record found:${JSON.stringify(unexpected)} in ${JSON.stringify(content)}`)
})

Then('we expect table {string} to have {int} records', async function( tableName, expectedRowCount ) {
  let content = await this.controller.extractTableContent(tableName);
  assert.equal(content.length, expectedRowCount)
})

Then('we expect table {string} to have {int} records in total', async function( tableName, expectedRowCount ) {
  let totalRowCount = await this.controller.extractTableRowsTotalCount(tableName);
  assert.equal(totalRowCount, expectedRowCount)
})

Then('we expect to have {int} table records', async function( expectedRowCount ) {
  let content = await this.controller.extractTableRows();
  assert.equal(content.length, expectedRowCount)
})

When('find protected data source', async function( ) {
  let inbounds = await this.controller.getInbounds();
  let inspect = require('../inspectInbounds')
  let urlBase = buildUrl(this.process);
  let res = await inspect(urlBase,inbounds)
  if(res['401'])
    console.log("Found",res['401'][0])
  else
    throw Error("Protected data source not found");
})

When('we wait for debugger to attach', async function( ) {
  await this.controller.waitDebuggerToAttach();
})

When('we wait {int} seconds for debugger to attach', async function( seconds ) {
  await this.controller.waitDebuggerToAttach(seconds);
})

function _sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

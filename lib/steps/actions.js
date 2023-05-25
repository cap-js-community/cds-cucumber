const { When } = require('@cucumber/cucumber');

When('we press button {string} in active dialog', async function( label ) {
  await this.controller.pressButtonInActiveDialog(label);
  await this.controller.waitToLoad();
})

When('we press button {string}', async function( label ) {
  await this.controller.pressButton(label);
  await this.controller.waitToLoad();
})

When('we create new item', async function() {
  await this.controller.pressButtonForLineItemTable('Create');
  await this.controller.waitToLoad();
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

When('we delete the object instance', async function() {
  await this.controller.deleteObjectInstance();
  await this.controller.waitEvents();
})

When('we confirm the deletion', async function() {
  await this.controller.pressButtonInDialog('Delete', 'Delete');
  await this.controller.waitToLoad();
})

When('we perform object action {string}', async function( label ) {
  await this.controller.pressObjectPageActionBarButton(label);
  await this.controller.waitEvents();
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

When('we tap on {string}', async function( textOrLink ) {
  this.result = await this.controller.tapOn(textOrLink);
  await this.controller.waitToLoad();
})

When('save the result', async function() {
  this.saved=this.result;
})

When('we tap on row {int} in table {string}', async function( row, tableName ) {
  if(row<1) throw Error(`row number should be greater than zero, got: ${row}`);
  await this.controller.tapOnRowInLineItemTable(tableName, row-1);
  await this.controller.waitEvents();
})

When('we apply the changes', async function() {
  await this.controller.applyChanges();
  await this.controller.waitToLoad();
})

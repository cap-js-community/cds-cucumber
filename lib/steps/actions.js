/** @namespace Actions **/

const { When } = require('@cucumber/cucumber');

/**
* @memberof Actions
* @name When we press button {string} in active dialog
* @description Press the specified button in the currently active dialog
* @example When we press button "Accept" in active dialog
*/
When('we press button {string} in active dialog', async function( label ) {
  await this.controller.pressButtonInActiveDialog(label);
  await this.controller.waitToLoad();
})

/**
* @memberof Actions
* @name When we press button {string}
* @description Press the specified button located on the current page
* @example When we press button "Create"
*/
When('we press button {string}', async function( label ) {
  await this.controller.pressButton(label);
  await this.controller.waitToLoad();
})

/**
* @memberof Actions
* @name When we create new item
* @description Triggers creation of a new item by pressing the "Create" button located on the current page
* @example When we create new item
*/
When('we create new item', async function() {
  await this.controller.pressButtonForLineItemTable('Create');
  await this.controller.waitToLoad();
})

/**
* @memberof Actions
* @name When we create new item for table {string}
* @description Triggers creation of a new item for the specified table located on the current page by pressing its "Create" button
* @param {string} tableName the name of the target table as displayed in the browser
* @example When we create new item for table "Books"
*/
When('we create new item for table {string}', async function( tableName ) {
  await this.controller.pressButtonForLineItemTable('Create', tableName);
  await this.controller.waitToLoad();
})

/**
* @memberof Actions
* @name When we delete selected rows in table {string}
* @description Triggers deletion of selected items for the specified table located on the current page by pressing its "Delete" button
* @param {string} tableName the name of the target table as displayed in the browser
* @example When we delete selected rows in table "Books"
*/
When('we delete selected rows in table {string}', async function( tableName ) {
  await this.controller.pressButtonForLineItemTable('Delete', tableName);
  await this.controller.waitEvents();
})

/**
* @memberof Actions
* @name When we create new item for table in section {string}
* @description Triggers creation of a new item for the table located in the section with the specified name by pressing its "Create" button
* @param {string} sectionName the name of the section as displayed in the browser which contais the target table
* @example When we create new item for table in section "Books"
*/
When('we create new item for table in section {string}', async function( sectionName ) {
  await this.controller.pressButtonForLineItemTableInSection('Create', sectionName);
  await this.controller.waitToLoad();
})

/**
* @memberof Actions
* @name When we delete the object instance
* @description Triggers deletion of the current object instance in an ObjectPage by pressing its "Delete" button
* @example When we delete the object instance
*/
When('we delete the object instance', async function() {
  await this.controller.deleteObjectInstance();
  await this.controller.waitEvents();
})

/**
* @memberof Actions
* @name When we confirm the deletion
* @description Confirms triggered deletion in the currently visible "Delete" dialog by pressing its "Delete" button
* @example When we confirm the deletion
*/
When('we confirm the deletion', async function() {
  await this.controller.pressButtonInDialog('Delete', 'Delete');
  await this.controller.waitToLoad();
})

/**
* @memberof Actions
* @name When we perform object action {string}
* @description Triggers the specified action of the current object instance located on an ObjectPage by pressing the button with the specified label
* @param {string} label the label of the target button as displayed in the browser
* @example When we perform object action "Reject"
*/
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

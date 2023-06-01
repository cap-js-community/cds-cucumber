/** @namespace Valuehelp **/

const { When } = require('@cucumber/cucumber');

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

When('we confirm value help dialog', async function( ) {
  await this.controller.pressOkInValueHelpDialog();
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

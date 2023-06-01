/** @namespace Draft **/

const { When } = require('@cucumber/cucumber');

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

When('we decide to save the draft', async function() {
  await this.controller.chooseItemInListDialog('Warning','Create');
  await this.controller.waitToLoad();
})

When('we edit current object', async function( ) {
  await this.controller.pressStandardActionButtonInObjectPageHeader('Edit');
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

When('we select draft editing status {string}', async function( text ) {
  await this.controller.selectItemInValueHelp('Editing Status', text);
  await this.controller.waitEvents();
})

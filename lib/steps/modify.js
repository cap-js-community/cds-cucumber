/** @namespace Modify **/

const { When } = require('@cucumber/cucumber');

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

When('we enter in the prompt {string}', async function( value ) {
  await this.controller.enterValueInPrompt(value);
  await this.controller.waitEvents();
})

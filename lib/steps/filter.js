const { When } = require('@cucumber/cucumber');

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

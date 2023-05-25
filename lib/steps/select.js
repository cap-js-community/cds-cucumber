const { When } = require('@cucumber/cucumber');

When('we select all rows in table {string}', async function( tableName ) {
  await this.controller.selectAllRowsLineItemTable(tableName);
  await this.controller.waitEvents();
})

When('we select row {int} in table {string}', async function( row, tableName ) {
  if(row<1) throw Error(`row number should be greater than zero, got: ${row}`);
  await this.controller.selectRowInLineItemTable(tableName, row-1);
  await this.controller.waitEvents();
})

When('we select rows in table {string} having {string} equal to {string}', async function( tableName, columnName, value ) {
  await this.controller.selectRowsInLineItemTableHaving(tableName, columnName, value);
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

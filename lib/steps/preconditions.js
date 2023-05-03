const { Given } = require('@cucumber/cucumber');

Given('table {string} has {int} records', async function( tableName, expectedRowCount ) {
  let totalRowCount = await this.controller.extractTableRowsTotalCount(tableName);
  assert.equal(totalRowCount, expectedRowCount)
})

Given('table {string} has {int} visible records', async function( tableName, expectedRowCount ) {
  let content = await this.controller.extractTableContent(tableName);
  assert.equal(content.length, expectedRowCount)
})

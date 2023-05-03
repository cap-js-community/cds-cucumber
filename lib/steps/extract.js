const { When } = require('@cucumber/cucumber');

When('we get the title of the page', async function() {
  this.result = await this.controller.getTitle();
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

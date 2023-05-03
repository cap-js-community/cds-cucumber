const { When } = require('@cucumber/cucumber');

When('we perform basic search for {string}', async function( text ) {
  await this.controller.performBasicSearch(text);
  await this.controller.waitEvents();
})

When('we enter in the search field {string}', async function( text ) {
  await this.controller.editSearchField(text);
  await this.controller.waitEvents();
})

When('we apply the search filter', async function( ) {
  await this.controller.applySearchFilter();
  await this.controller.waitToLoad();
})

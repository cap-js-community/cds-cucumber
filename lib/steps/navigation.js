const { Given, Before, After, setDefaultTimeout, When } = require('@cucumber/cucumber');

When('we click on first Fiori preview page', async function() {
  await this.controller.clickOnElementWithClass('preview');
  await this.controller.waitToLoad(100);
  if(!await this.controller.initializeLibrary())
    throw Error('Failed to initialize the library!');
  await this.controller.waitBlockers(5000);
})

When('we list all tiles', async function() {
  this.result = await this.controller.getTiles();
})

When('we select tile {string}', async function(tile) {
  await this.controller.pressTile(tile);
  await this.controller.waitToLoad();
})

When('we go back', async function() {
  await this.controller.back();
  await this.controller.waitBlockers(200);
})

When('we navigate back', async function() {
  await this.controller.pressGoBackButton();
  await this.controller.waitToLoad();
})

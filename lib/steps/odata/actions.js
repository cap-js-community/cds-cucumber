/**
 * @module Actions
 * @memberof OData
*/

const { When } = require('@cucumber/cucumber');

/**
* @name When we execute action {word} with payload
* @description Performs the specified action
* @param {word} actionName name of the action
* @param {attachment} payload JSON-formatted string specifying the payload to pass as argument
* @example When we execute action submitOrder with payload
*/
When('we execute action {word} with payload', async function( actionName, payload) {
  await this.cdsService.send({
    method: 'POST',
    path: actionName,
    data: JSON.parse(payload)
  })
})

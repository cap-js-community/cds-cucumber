console.log("--------- PLUGIN: LOCAL UI5 COUNTER ----------------")

const cds = require('@sap/cds')

let count = 0;

async function resources(req, res, next) {
  console.log("get", req.originalUrl)
//  let url = "https://sapui5.hana.ondemand.com"+req.originalUrl.substring(6);
  let url = ""+req.originalUrl.substring(6);
  console.log("->",url)
  res.redirect(url);
  count++;
  next()
}

async function stats(req, res, next) {
  console.log("get", req.originalUrl)
  res.send(""+count);
  next()
}

cds.on('bootstrap', async (app) => {
  app.use('/stats', stats)
  app.use('/proxy/resources', resources)
  app.use('/proxy/test-resources', resources)
})

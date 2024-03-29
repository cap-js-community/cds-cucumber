#!/bin/bash
set -e
set -x

ROOT=`pwd`

DIR=tmp/add-local-ui5-build-plugin

test -d ${DIR} && rm -r -f ${DIR}
mkdir -p ${DIR}
cd ${DIR}

npm init -y

npm init -w dk -y
npm i -w dk @sap/cds-dk

npm init -w service -y

cd service
rm package.json

npx cds init --add samples,sqlite && npx cds deploy --to sqlite
npm i @sap/cds
npm i express

node ${ROOT}/cds-plugins/addCdsPlugin.js -p local-ui5-build -f app/fiori-apps.html

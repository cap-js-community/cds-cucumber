#!/bin/bash

set -e
set -x

ROOT_DIR=`pwd`

. ${ROOT_DIR}/test/bin/.sapui5.version.sh

WORK_DIR=tmp/mtx

#test -d ${WORK_DIR} && rm -r -f ${WORK_DIR}
test -d ${WORK_DIR} || mkdir -p ${WORK_DIR}

cd ${WORK_DIR}

test -f package.json || npm init -y

#test -d cds-cucumber && rm -r cds-cucumber
if [ -d cds-cucumber ]; then
echo cds cucumber alerady added
else
npm init -w cds-cucumber -y

cat <<EOF >cds-cucumber/package.json
{
  "name": "cds-cucumber",
  "version": "0.1.0-beta1",
  "bin": {
    "cds-add-cucumber": "./bin/cds-add-cucumber.js",
    "cds-add-cucumber-plugin": "./cds-plugins/addCdsPlugin.js"
  },
  "main": "./lib/index.js",
  "dependencies": {
    "@sap-cloud-sdk/http-client": "^3.3.0",
    "@sap-cloud-sdk/resilience": "^3.3.0",
    "@sap/cds": "^7.0.3",
    "chai": "^4.3.7",
    "chai-shallow-deep-equal": "^1.4.6",
    "chromedriver": "^115.0.0",
    "selenium-webdriver": "^4.11.1",
    "sqlite3": "^5.1.6",
    "tree-kill": "^1.2.2",
    "@cucumber/cucumber": "^9.2.0"
  }
}
EOF

npm add cds-cucumber

fi

cp -r ${ROOT_DIR}/bin cds-cucumber
cp -r ${ROOT_DIR}/lib cds-cucumber
cp -r ${ROOT_DIR}/cds-plugins cds-cucumber

if [ -d dk ]; then
  echo dk already created
else
  npm init -w dk -y
  npm i -w dk @sap/cds-dk
fi

if [ -d service ]; then
  cd service
else
  npm init -w service -y
  cd service
  rm package.json
  npx cds init --add sample,sqlite
  npx cds add multitenancy
  npx cds deploy --to sqlite
fi

if [ -f cucumber.yml ]; then
  echo cucumber already enabled
else
  npm add cds-cucumber
  npx cds-add-cucumber
  # requireModule does not work with links -> require the steps directly
fi

if [ -d ${ROOT_DIR}/tmp/sapui5/full-${SAP_UI5_VERSION}/dist ]; then
  export SAPUI5_DIST_DIRECTORY=${ROOT_DIR}/tmp/sapui5/full-${SAP_UI5_VERSION}/dist
  echo "Found UI5 local build: ${SAPUI5_DIST_DIRECTORY}"
else
  if [ -d ${ROOT_DIR}/../sapui5/full-${SAP_UI5_VERSION}/dist ]; then
    export SAPUI5_DIST_DIRECTORY=${ROOT_DIR}/../sapui5/full-${SAP_UI5_VERSION}/dist
    echo "Found UI5 local build: ${SAPUI5_DIST_DIRECTORY}"
  fi
fi

if [ -d ../local-ui5-build-plugin ]; then
  echo local ui5 already enabled
else
  npx cds-add-cucumber-plugin -p local-ui5-build -f app/index.html
fi

test -d test/features && rm -r test/features && mkdir -p test/features
cp -r ${ROOT_DIR}/test/features/mtx test/features

npx cucumber-js test/features/mtx

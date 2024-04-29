#!/bin/bash

set -e
set -x

ROOT=`pwd`

CURRENT_VERSION=`npm pkg get version`
echo "CURRENT_VERSION: ${CURRENT_VERSION:1:-1}"

WORK_DIR=${ROOT}/tmp/plugin-ui5-build

if [ -d ${WORK_DIR} ]; then
  echo "Working directory: ${WORK_DIR}"
  cd ${WORK_DIR}

else

test -d ${WORK_DIR} && rm -r -f ${WORK_DIR}
mkdir -p ${WORK_DIR}

npm pack --pack-destination=${WORK_DIR}

cd ${WORK_DIR}

npm init -y

npm init -w dk -y
npm i -w dk @sap/cds-dk

npm init -w service -y

cd service
rm package.json

npx cds init --add sample,sqlite && npx cds deploy --to sqlite
npm i @sap/cds
npm i express

npm i ${ROOT}/cap-js-community-cds-cucumber-${CURRENT_VERSION:1:-1}.tgz

npx cds-add-cucumber
npx cds-add-cucumber-plugin -p local-ui5-tgz -f ./app/index.html

fi

export SAP_UI5_VERSION="1.123.1"
cd ${WORK_DIR}

bash ./node_modules/@cap-js-community/cds-cucumber/cds-plugins/local-ui5-tgz/build.sh

export SAPUI5_ARCHIVE_FILE=${WORK_DIR}/tmp/sapui5/sapui5-${SAP_UI5_VERSION}.tgz

cd service
npx cucumber-js test

#!/bin/bash

set -e
set -x

. ./test/bin/.sapui5.version.sh

if [ "${CDS_VERSION}" == "" ]; then
  export CDS_VERSION="^7.0.0"
fi

ROOT_DIR=`pwd`
DIR=tmp/getting-started-locally-reuse-local-ui5-cds-${CDS_VERSION/\^/}

test -d $DIR && rm -r -f $DIR
test -d ${DIR} || mkdir -p $DIR
cd $DIR
test -f package.json || npm init -y
test -d dk || npm init -w dk -y
test -d node_modules/@sap/cds-dk || npm i -w dk @sap/cds-dk@${CDS_VERSION}

if [ -d "service" ]; then
  echo "Service already generated."
  cd service
else
  npm init -w service -y
  rm service/package.json
  cd service

  npx cds init --add sample,sqlite && npx cds deploy --to sqlite
  npm i @sap/cds@${CDS_VERSION}
  npm i express
  if [ "$BRANCH_NAME" == "" ]; then
    npm i ../../.. || true
  else
    npm i -D git+https://github.com/cap-js-community/cds-cucumber.git#$BRANCH_NAME
  fi
fi

if [ -f "cucumber.yml" ]; then
  echo "Cucumber already enabled."
else
npx cds-add-cucumber

if [ "$BRANCH_NAME" == "" ]; then
# requireModule does not work with links -> require the steps directly
cat <<EOF >cucumber.yml
default:
    publishQuiet: true
    require:
      - ../../../lib/index.js
EOF
fi

fi

export SAPUI5_DIST_DIRECTORY=${ROOT_DIR}/tmp/sapui5/full-${SAP_UI5_VERSION}/dist
if [ -d ${SAPUI5_DIST_DIRECTORY} ]; then
  echo "Found UI5 local build: ${SAPUI5_DIST_DIRECTORY}"
else
  exit 1
fi

if [ -d "../local-ui5-build-plugin" ]; then
  echo "Plugin local-ui5-build already installed."
else
  npx cds-add-cucumber-plugin -p local-ui5-build -f app/index.html
fi

cp test/features/bookshop.feature test/features/bookshop1.feature
npx cucumber-js test --parallel 2

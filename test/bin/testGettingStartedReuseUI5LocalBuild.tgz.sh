#!/bin/bash

set -e
set -x

. ./test/bin/.sapui5.version.sh

ROOT_DIR=`pwd`
DIR=tmp/getting-started-locally-reuse-local-ui5-tgz

#test -d $DIR && rm -r -f $DIR
test -d ${DIR} || mkdir -p $DIR
cd $DIR
test -f package.json || npm init -y
test -d dk || npm init -w dk -y
test -d node_modules/@sap/cds-dk || npm add -w dk @sap/cds-dk

if [ -d "service" ]; then
  echo "Service already generated."
  cd service
else
  npm init -w service -y
  rm service/package.json
  cd service

  npx cds init --add sample
  if [ "$BRANCH_NAME" == "" ]; then
    npm add ../../.. || true
  else
    npm add -D git+https://github.com/cap-js-community/cds-cucumber.git#$BRANCH_NAME
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
    require:
      - ../../../lib/index.js
EOF
fi

fi

. ${ROOT_DIR}/test/bin/.sapui5.tgz.sh
if [ -f "${SAPUI5_ARCHIVE_FILE}" ]; then
  echo "Found UI5 local tgz build: ${SAPUI5_ARCHIVE_FILE}"
else
  echo "Could not find UI5 local tgz build"
  exit 1
fi

if [ -d "../local-ui5-tgz-plugin" ]; then
  echo "Plugin local-ui5-build already installed."
else
  npx cds-add-cucumber-plugin -p local-ui5-tgz -f app/index.html
fi

cp test/features/bookshop.feature test/features/bookshop1.feature
npx cucumber-js test --parallel 2

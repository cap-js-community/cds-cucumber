#!/bin/bash

set -e
#set -x

. ./test/bin/.sapui5.version.sh

ROOT_DIR=`pwd`
DIR=tmp/try-bookshop-with-local-ui5-plugin-odata

export NODE_PATH=${DIR}/node_modules

#test -d $DIR && rm -r -f $DIR
test -d $DIR || mkdir -p $DIR
cd $DIR

test -d cloud-cap-samples || git clone https://github.com/SAP-samples/cloud-cap-samples.git --single-branch

cd cloud-cap-samples

test -d node_modules || npm i
test -d node_modules/sqlite3 || npm i -D sqlite3
test -d cds-cucumber || mkdir cds-cucumber
cp -v -r ${ROOT_DIR}/lib cds-cucumber

if [ "$BRANCH_NAME" == "" ]; then
  test -d node_modules/@cap-js-community/cds-cucumber ||  npm i -D ../../..
else
  test -d node_modules/@cap-js-community/cds-cucumber ||  npm i -D git+https://github.com/cap-js-community/cds-cucumber.git#$BRANCH_NAME
fi

. ${ROOT_DIR}/test/bin/.sapui5.dist.dir.sh
if [ -d ${SAPUI5_DIST_DIRECTORY} ]; then
  echo "Found UI5 local build: ${SAPUI5_DIST_DIRECTORY}"
else
  echo "Could not find UI5 local build"
  exit 1
fi

test -d local-ui5-build-plugin || npx cds-add-cucumber-plugin -p local-ui5-build -w fiori -f app/fiori-apps.html

test -f cucumber.yml || npx cds-add-cucumber

if [ "$BRANCH_NAME" == "" ]; then
cat <<EOF >cucumber.yml
default:
    require:
      - ./cds-cucumber/lib/index.js
EOF
fi

# clean test files
test -d test/features && rm -r -f test/features
test -d test/features || mkdir -p test/features
cp -r ../../../test/features/bookshop test/features

export CDS_SERVICE_APPLICATION=fiori
export CDS_COMMAND_ARG1="--with-mocks"
export CDS_COMMAND_ARG2="--in-memory?"

export CDS_USERNAME=alice
export CDS_PASSWORD=admin

npx cucumber-js test/features/bookshop/odata --tags "not @todo"

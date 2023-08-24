#!/bin/bash

set -x
set -e

. ./test/bin/.sapui5.version.sh

ROOT_DIR=`pwd`
DIR=tmp/try-bookshop-with-local-ui5-plugin

#test -d $DIR && rm -r -f $DIR
test -d $DIR || mkdir -p $DIR
cd $DIR

test -d cloud-cap-samples || git clone https://github.com/SAP-samples/cloud-cap-samples.git --single-branch

cd cloud-cap-samples

test -d node_modules || npm i
test -d node_modules/sqlite3 || npm i -D sqlite3

if [ "$BRANCH_NAME" == "" ]; then
  test -d node_modules/@cap-js-community/cds-cucumber ||  npm i -D ../../..
else
  test -d node_modules/@cap-js-community/cds-cucumber ||  npm i -D git+https://github.com/cap-js-community/cds-cucumber.git#$BRANCH_NAME
fi

DIR_CANDIDATE=${ROOT_DIR}/tmp/sapui5/full-${SAP_UI5_VERSION}/dist
if [ -d ${DIR_CANDIDATE} ]; then
  export SAPUI5_DIST_DIRECTORY=${DIR_CANDIDATE}
  echo "Found UI5 local build: ${SAPUI5_DIST_DIRECTORY}"
fi

test -d local-ui5-build-plugin || npx cds-add-cucumber-plugin -p local-ui5-build -w fiori -f app/fiori-apps.html

test -f cucumber.yml || npx cds-add-cucumber

if [ "$BRANCH_NAME" == "" ]; then
cat <<EOF >cucumber.yml
default:
    require:
      - ../../../lib/index.js
EOF
fi

test -f test/features/bookshop || cp -r ../../../test/features/bookshop test/features

export CDS_SERVICE_APPLICATION=fiori
export CDS_COMMAND_ARG1="--with-mocks"
export CDS_COMMAND_ARG2="--in-memory?"

export CDS_USERNAME=alice
export CDS_PASSWORD=admin

export THREADS=$((`nproc --all` - 1))
npx cucumber-js test/features/bookshop --tags "not @todo" --parallel $THREADS

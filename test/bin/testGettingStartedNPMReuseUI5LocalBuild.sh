#!/bin/bash

set -e
set -x

DIR=tmp/getting-started-npm-reuse-local-ui5
ROOT_DIR=`pwd`

test -d $DIR && rm -r -f $DIR
test -d ${DIR} || mkdir -p $DIR
cd $DIR

npm init -y

npm init -w dk -y
npm i -w dk @sap/cds-dk

npm init -w service -y

cd service
rm package.json

npx cds init
npx cds add sample

npm i -D @cap-js-community/cds-cucumber
npx cds-add-cucumber


. ${ROOT_DIR}/test/bin/.sapui5.version.sh
. ${ROOT_DIR}/test/bin/.sapui5.dist.dir.sh
if [ -d ${SAPUI5_DIST_DIRECTORY} ]; then
  echo "Found UI5 local build: ${SAPUI5_DIST_DIRECTORY}"
else
  echo "Could not find UI5 local build"
  exit 1
fi

npx cds-add-cucumber-plugin -p local-ui5-build -f app/index.html

npx cucumber-js test

#!/bin/bash

set -e
set -x

. ./test/bin/.sapui5.version.sh

ROOT_DIR=`pwd`

CURRENT_VERSION=`npm pkg get version`
echo "CURRENT_VERSION: ${CURRENT_VERSION:1:-1}"

WORK_DIR=${ROOT_DIR}/tmp/codecov-getting-started

#test -d $WORK_DIR && rm -r -f $WORK_DIR
test -d ${WORK_DIR} || mkdir -p $WORK_DIR

export PACKED_FILE=${WORK_DIR}/cap-js-community-cds-cucumber-${CURRENT_VERSION:1:-1}.tgz
rm $PACKED_FILE
if [ -f ${PACKED_FILE} ]; then
  echo "cds-cucumber already packed: ${PACKED_FILE}"
else
  npm pack --pack-destination=${WORK_DIR}
fi

cd $WORK_DIR

if [ -f package.json ]; then
  echo "package.json already initialized"
else
  npm init -y
  test -d node_modules/@sap/cds-dk || npm add @sap/cds-dk
fi

if [ -f .cdsrc.json ]; then
  echo "cds sample already initialized"
else
  npx cds init --add sample
fi

npm add ${PACKED_FILE}

if [ -f "cucumber.yml" ]; then
  echo "cucumber already enabled"
else
  npx cds-add-cucumber
fi

. ${ROOT_DIR}/test/bin/.sapui5.tgz.sh
if [ -f "${SAPUI5_ARCHIVE_FILE}" ]; then
  echo "Found UI5 local tgz build: ${SAPUI5_ARCHIVE_FILE}"
else
  echo "Could not find UI5 local tgz build"
  exit 1
fi

if [ -d "local-ui5-tgz-plugin" ]; then
  echo "plugin local-ui5-build already installed"
else
  npx cds-add-cucumber-plugin -p local-ui5-tgz -f app/index.html
fi

cp test/features/bookshop.feature test/features/bookshop1.feature

if [ -d "./node_modules/c8" ]; then
  echo "c8 already added"
else
  npm add -D c8
fi

export CDS_COMMAND_ARG1="--with-mocks"
export CDS_COMMAND_ARG2="--in-memory?"

cat <<EOF >.c8rc.json
{
  "excludeNodeModules": false,
  "include": [
    "srv",
    "node_modules/@sap/cds"
  ]
}
EOF

rm -r -f tmp/coverage
CDS_CUCUMBER_CODECOV="c8" npx cucumber-js test
ls -altr ${WORK_DIR}/tmp/coverage/index.html

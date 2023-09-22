#!/bin/bash

set -e

ROOT_DIR=`pwd`

. ./test/bin/.sapui5.version.sh

echo "Build SAP UI5 version ${SAP_UI5_VERSION}"

TGZ_DIR=${ROOT_DIR}/tmp/sapui5
TGZ_FILE=${TGZ_DIR}/sapui5-${SAP_UI5_VERSION}.tgz

if [ -f ${TGZ_FILE} ]; then
  echo "    -> ${TGZ_FILE}"
else

WORK_DIR=${TGZ_DIR}/${SAP_UI5_VERSION}

#test -d ${DIR} && rm -r -f ${DIR}
test -d ${WORK_DIR} || mkdir -p ${WORK_DIR}

cp -r cds-plugins/local-ui5-build/files/* ${WORK_DIR}

cd ${WORK_DIR}

test -f package.json || npm init -y
test -d node_modules/@ui5/cli || npm i @ui5/cli
npx ui5 use sapui5@${SAP_UI5_VERSION}
npm version "${SAP_UI5_VERSION}" || true
#test -d dist || npx ui5 build preload --all --include-task generateVersionInfo
test -d dist || npx ui5 build self-contained --all --include-task generateVersionInfo

cd dist
tar -cvzf ${TGZ_FILE} resources test-resources
echo "  -> ${TGZ_FILE}"

cd ${ROOT_DIR}
test -f ${WORK_DIR}/ui5.yaml && rm -r ${WORK_DIR}

fi

#!/bin/bash

set -e

ROOT_DIR=`pwd`

if [ -z "${SAP_UI5_VERSION}" ]; then
  echo "SAP_UI5_VERSION is not set"
  exit 1
fi

echo "Build SAP UI5 version ${SAP_UI5_VERSION}"

TGZ_DIR=${ROOT_DIR}/tmp/sapui5
TGZ_FILE=${TGZ_DIR}/sapui5-${SAP_UI5_VERSION}.tgz

if [ -f ${TGZ_FILE} ]; then
  echo "    -> ${TGZ_FILE}"
  exit 0
fi

WORK_DIR=${TGZ_DIR}/${SAP_UI5_VERSION}

test -d ${WORK_DIR} || mkdir -p ${WORK_DIR}

if [ -d "./cds-plugins/local-ui5-build" ]; then
  PLUGIN_DIR="./cds-plugins/local-ui5-build"
else
  if [ -d "./node_modules/@cap-js-community/cds-cucumber/cds-plugins/local-ui5-build" ]; then
    PLUGIN_DIR="./node_modules/@cap-js-community/cds-cucumber/cds-plugins/local-ui5-build"
  else
    echo "Plugin not found"
    exit 1
  fi
fi

echo "Plugin directory: ${PLUGIN_DIR}"

cp -r ${PLUGIN_DIR}/files/* ${WORK_DIR}

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

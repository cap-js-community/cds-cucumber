#!/bin/bash

set -e
set -x

. ./test/bin/.sapui5.version.sh

DIR=tmp/sapui5/full-${SAP_UI5_VERSION}

test -d ${DIR} && rm -r -f ${DIR}
test -d ${DIR} || mkdir -p ${DIR}

cp -v -r cds-plugins/local-ui5-build/files/* ${DIR}
ls -altr ${DIR}

cd ${DIR}

test -f package.json || npm init -y
test -d node_modules/@ui5/cli || npm i @ui5/cli
npx ui5 use sapui5@${SAP_UI5_VERSION}
npm version "${SAP_UI5_VERSION}"
#test -d dist || npx ui5 build preload --all --include-task generateVersionInfo
test -d dist || npx ui5 build self-contained --all --include-task generateVersionInfo

ls -altr .

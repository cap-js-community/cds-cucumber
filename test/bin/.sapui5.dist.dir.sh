#!/bin/bash

if [ -z "${SAP_UI5_VERSION}" ]; then
  echo "SAP_UI5_VERSION is not set"
  exit 1
fi

DIR_CANDIDATE=${ROOT_DIR}/tmp/sapui5/full-${SAP_UI5_VERSION}/dist
if [ -d ${DIR_CANDIDATE} ]; then
  export SAPUI5_DIST_DIRECTORY=${DIR_CANDIDATE}
  echo "Found UI5 local build: ${SAPUI5_DIST_DIRECTORY}"
fi

DIR_CANDIDATE=${ROOT_DIR}/../tmp/sapui5/full-${SAP_UI5_VERSION}/dist
if [ -d ${DIR_CANDIDATE} ]; then
  export SAPUI5_DIST_DIRECTORY=${DIR_CANDIDATE}
  echo "Found UI5 local build: ${SAPUI5_DIST_DIRECTORY}"
fi

#!/bin/bash

ARGS="$@"

set -x
set -e

. ${CDS_CUCUMBER_PLUGIN_DIR}/.sapui5.version.sh

if [ "${SAPUI5_DIST_DIRECTORY}" = "" ]; then
  echo "Build UI5"
  npm i @ui5/cli
  npx ui5 use sapui5@${SAP_UI5_VERSION}
  npm version ${SAP_UI5_VERSION}
  # ./build.preload.sh
  ./build.self-contained.sh
else  
  echo "Reuse UI5 build: ${SAPUI5_DIST_DIRECTORY}"
fi

cd ${CDS_SERVICE_ROOT_DIR}
node ${CDS_CUCUMBER_PLUGIN_DIR}/modifyHtmlFiles.js $ARGS

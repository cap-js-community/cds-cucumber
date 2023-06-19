#!/bin/bash

ARGS="$@"

set -x
set -e

npm i @ui5/cli
####npx ui5 build preload --all --include-task generateVersionInfo
npx ui5 build self-contained --all --include-task generateVersionInfo

cd ${CDS_SERVICE_ROOT_DIR}
node ${CDS_CUCUMBER_PLUGIN_DIR}/init.js $ARGS

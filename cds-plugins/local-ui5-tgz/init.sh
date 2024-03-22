#!/bin/bash

ARGS="$@"

set -x

test -d node_modules/tar-stream || npm add tar-stream

cd ${CDS_SERVICE_ROOT_DIR}
node ${CDS_CUCUMBER_PLUGIN_DIR}/modifyHtmlFiles.js $ARGS

#!/bin/bash

export CUCUMBER_PUBLISH_ENABLED=false
export CUCUMBER_PUBLISH_QUIET=true

export CDS_COMMAND=watch
export CDS_SERVICE_DIR=tmp/cloud-cap-samples/fiori
export CDS_CUCUMBER_DEBUG=1
#export SHOW_BROWSER=1
export CDS_SERVICE_PORT=4004
#export CDS_CUCUMBER_LIB_FILE_NAME="browser.js"

npx cucumber-js test/features/internal/debug.feature

#!/bin/bash

export CUCUMBER_PUBLISH_ENABLED=false
export CUCUMBER_PUBLISH_QUIET=true

export CDS_COMMAND=watch
export TEST_SERVICE_DIR=tmp/cloud-cap-samples/fiori

npx cucumber-js test/features/bookshop/read/tiles.feature

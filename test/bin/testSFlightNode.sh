#!/bin/bash

export CUCUMBER_PUBLISH_ENABLED=false
export CUCUMBER_PUBLISH_QUIET=true

export TEST_USER=alice
export TEST_PASSWORD=admin
export TEST_SERVICE_DIR=tmp/cap-sflight

npx cucumber-js test/features/sflight --fail-fast --tags "not @skip:node"

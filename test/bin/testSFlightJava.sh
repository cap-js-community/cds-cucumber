#!/bin/bash

export CUCUMBER_PUBLISH_ENABLED=false
export CUCUMBER_PUBLISH_QUIET=true

export CDS_STACK=java
export CDS_USERNAME=admin
export CDS_PASSWORD=admin
export CDS_SERVICE_DIR=tmp/cap-sflight

npx cucumber-js test/features/sflight --tags "not @skip:java"

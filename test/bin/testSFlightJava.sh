#!/bin/bash

export CDS_STACK=java
export CDS_USERNAME=admin
export CDS_PASSWORD=admin
export CDS_SERVICE_DIRECTORY=tmp/cap-sflight

npx cucumber-js test/features/sflight --tags "not @skip:java"

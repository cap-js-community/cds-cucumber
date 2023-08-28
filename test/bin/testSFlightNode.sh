#!/bin/bash

export CDS_USERNAME=alice
export CDS_PASSWORD=admin
export CDS_SERVICE_DIRECTORY=tmp/cap-sflight

npx cucumber-js test/features/sflight --tags "not @skip:node"

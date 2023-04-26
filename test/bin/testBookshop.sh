#!/bin/bash

export CDS_COMMAND=watch
export TEST_SERVICE_DIR=tmp/cloud-cap-samples/fiori
npx cucumber-js test/features/bookshop/read/tiles.feature

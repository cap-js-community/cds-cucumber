#!/bin/bash

set -e

####################################

export CDS_SERVICE_DIRECTORY=tmp/cloud-cap-samples/fiori
export CDS_COMMAND_ARG1="--with-mocks"
export CDS_COMMAND_ARG2="--in-memory?"

npx cucumber-js test/features/bookshop/read/tiles.feature

####################################

export CDS_SERVICE_DIRECTORY=tmp/cloud-cap-samples
export CDS_SERVICE_APPLICATION=fiori
export CDS_COMMAND_ARG1="--with-mocks"
export CDS_COMMAND_ARG2="--in-memory?"

npx cucumber-js test/features/bookshop/read/tiles.feature

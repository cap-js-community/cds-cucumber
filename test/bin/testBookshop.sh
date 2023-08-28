#!/bin/bash

export CDS_SERVICE_DIRECTORY=tmp/cloud-cap-samples/fiori
export CDS_COMMAND_ARG1="--with-mocks"
export CDS_COMMAND_ARG2="--in-memory?"

npx cucumber-js test/features/bookshop --tags "not @todo"

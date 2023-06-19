#!/bin/bash

if [ "x$BRANCH_NAME" == "x" ]; then
  echo BRANCH_NAME not set $BRANCH_NAME
else
  echo BRANCH_NAME set $BRANCH_NAME
fi

set -x
set -e

DIR=tmp/try-samples-with-local-ui5-plugin

#test -d $DIR && rm -r -f $DIR
test -d $DIR || mkdir -p $DIR
cd $DIR

test -d cloud-cap-samples || git clone https://github.com/SAP-samples/cloud-cap-samples.git --single-branch

cd cloud-cap-samples

test -d node_modules || npm i

test -d node_modules/@sap/cds-dk || npm i @sap/cds-dk

if [ "x$BRANCH_NAME" == "x" ]; then
  test -d node_modules/@cap-js-community/cds-cucumber ||  npm i -D ../../..
else
  test -d node_modules/@cap-js-community/cds-cucumber ||  npm i -D git+https://$TOKEN@github.com/cap-js-community/cds-cucumber.git#$BRANCH_NAME
fi

test -d local-ui5-build-plugin || npx cds-add-cucumber-plugin -p local-ui5-build -w fiori -f app/fiori-apps.html

test -f cucumber.yml || npx cds-add-cucumber

if [ "x$BRANCH_NAME" == "x" ]; then
cat <<EOF >cucumber.yml
default:
    publishQuiet: true
    require:
      - ../../../lib/index.js
EOF
fi

test -f test/features/list.tiles.feature || cat <<EOF >test/features/list.tiles.feature
Feature: List tiles

  Scenario: List all tiles
    Given we have started the application
      And we have opened the url "fiori-apps.html"
    When we list all tiles
    Then we expect the result to match array ignoring element order
    """
    [
      "Browse Books",
      "Browse Genres (OData v2)",
      "Manage Books",
      "Manage Authors",
      "Manage Orders"
    ]
    """
EOF

export CDS_SERVICE_DIR=fiori
export CDS_COMMAND=watch
export CDS_USERNAME=alice
export CDS_PASSWORD=admin

npx cucumber-js test

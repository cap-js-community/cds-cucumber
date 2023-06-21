#!/bin/bash

set -x
set -e

DIR=tmp/try-sflight-with-local-ui5-plugin

#test -d $DIR && rm -r -f $DIR
test -d $DIR || mkdir -p $DIR
cd $DIR

test -d cap-sflight || git clone https://github.com/SAP-samples/cap-sflight.git --single-branch

cd cap-sflight

test -d node_modules || npm i

test -d node_modules/@sap/cds-dk || npm i @sap/cds-dk

if [ "$BRANCH_NAME" == "" ]; then
  test -d node_modules/@cap-js-community/cds-cucumber ||  npm i -D ../../..
else
  test -d node_modules/@cap-js-community/cds-cucumber ||  npm i -D git+https://$TOKEN@github.com/cap-js-community/cds-cucumber.git#$BRANCH_NAME
fi

test -d local-ui5-build-plugin || npx cds-add-cucumber-plugin -p local-ui5-build -f app/travel_processor/webapp/index.html

test -f cucumber.yml || npx cds-add-cucumber

if [ "$BRANCH_NAME" == "" ]; then
cat <<EOF >cucumber.yml
default:
    publishQuiet: true
    require:
      - ../../../lib/index.js
EOF
fi

test -f test/features/list.tiles.feature || cat <<EOF >test/features/travel.count.feature
Feature: Check total travel record count

  Scenario: Check total count of records in table Travels
    Given we have started the application
      And we have opened the url "/travel_processor/webapp/index.html"
    Then we expect table "Travels" to have 4133 records in total
EOF

export CDS_USERNAME=alice
export CDS_PASSWORD=admin

npx cucumber-js test

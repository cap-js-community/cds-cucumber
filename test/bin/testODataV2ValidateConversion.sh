#!/bin/bash

set -e
set -x

. ./test/bin/.sapui5.version.sh

ROOT_DIR=`pwd`

CURRENT_VERSION=`npm pkg get version`
echo "CURRENT_VERSION: ${CURRENT_VERSION:1:-1}"

WORK_DIR=${ROOT_DIR}/tmp/odata-v2-validate-conversion

#test -d $WORK_DIR && rm -r -f $WORK_DIR
test -d ${WORK_DIR} || mkdir -p $WORK_DIR

export PACKED_FILE=${WORK_DIR}/cap-js-community-cds-cucumber-${CURRENT_VERSION:1:-1}.tgz
test -f $PACKED_FILE && rm $PACKED_FILE
if [ -f ${PACKED_FILE} ]; then
  echo "cds-cucumber already packed: ${PACKED_FILE}"
else
  npm pack --pack-destination=${WORK_DIR}
fi

cd $WORK_DIR

if [ -f package.json ]; then
  echo "package.json already initialized"
else
  npm init -y
  test -d node_modules/@sap/cds-dk || npm add @sap/cds-dk
  rm package.json
fi

if [ -f .cdsrc.json ]; then
  echo "cds sample already initialized"
else
  npx cds init --add sample
fi

npm add ${PACKED_FILE}

if [ -f "cucumber.yml" ]; then
  echo "cucumber already enabled"
else
  npx cds-add-cucumber
fi

. ${ROOT_DIR}/test/bin/.sapui5.tgz.sh
if [ -f "${SAPUI5_ARCHIVE_FILE}" ]; then
  echo "Found UI5 local tgz build: ${SAPUI5_ARCHIVE_FILE}"
else
  echo "Could not find UI5 local tgz build"
  exit 1
fi

if [ -d "local-ui5-tgz-plugin" ]; then
  echo "plugin local-ui5-build already installed"
else
  npx cds-add-cucumber-plugin -p local-ui5-tgz -f app/index.html
fi

test -f test/features/bookshop.feature && rm test/features/bookshop.feature
find test/features "*.feature" || true

cat <<EOF > test/features/odata.feature
Feature: OData steps

  Scenario: List all books CatalogService
    Given we have started the application
      And we require communication protocol "odata-v2"
      And we have connected to service CatalogService as user "alice" with password ""
      And we prepare to read entity Books
      And select its stock
      And select its ID
      And field ID equals 201
      And do perform the read
      And we expect the result to contain the following record
      """
      { "stock": 12, "ID": 201 }
      """

    # odata-v2: deletion of "d"
    When we execute action submitOrder with payload
      """
      { "d": { "book": 201, "quantity": 1 } }
      """

    # odata-v2: type conversion - String to Integer
      And we execute action submitOrder with payload
      """
      { "book": "201", "quantity": "1" }
      """

    Then we prepare to read entity Books
      And select its stock
      And select its ID
      And field ID equals 201
      And do perform the read
      And we expect the result to contain the following record
      """
      { "stock": 10, "ID": 201 }
      """

EOF

cat <<EOF > srv/odataV2.cds
using { AdminService } from './admin-service';

annotate CatalogService with 
@protocol: [
  { kind: 'odata-v2', path: '/odata/v2/catalog' },
  { kind: 'odata-v4', path: '/odata/v4/catalog' }
];

annotate AdminService with 
@protocol: [
  { kind: 'odata-v2', path: '/odata/v2/admin' },
  { kind: 'odata-v4', path: '/odata/v4/admin' }
];

EOF

npm add @cap-js-community/odata-v2-adapter

export CDS_COMMAND_ARG1="--with-mocks"
export CDS_COMMAND_ARG2="--in-memory?"

npx cucumber-js test

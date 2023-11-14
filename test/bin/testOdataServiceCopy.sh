#!/bin/bash

set -e
#set -x

ROOT=`pwd`
TEST_DIR=tmp/odata-copy

#test -d ${TEST_DIR} && rm -r -f ${TEST_DIR}
test -d ${TEST_DIR} || mkdir -p ${TEST_DIR}

cd ${TEST_DIR}
WORK_DIR=`pwd`

export NODE_PATH=${WORK_DIR}/node_modules

test -f package.json || npm init -y
test -d node_modules/@sap/cds-dk || npm i @sap/cds-dk
test -d node_modules/express || npm i express
test -d node_modules/sqlite3 || npm i sqlite3
test -d node_modules/@sap-cloud-sdk/resilience || npm i @sap-cloud-sdk/resilience
test -d node_modules/@sap-cloud-sdk/http-client || npm i @sap-cloud-sdk/http-client

test -f .cdsrc.json || cp -r ${ROOT}/test/Vega/.cdsrc.json .
test -d db || cp -r ${ROOT}/test/Vega/db db
test -d srv || cp -r ${ROOT}/test/Vega/srv srv

test -f db.sqlite || npx cds deploy --to sqlite

cat <<EOF >cucumber.yml
default:
    require:
      - ../../lib/index.js
EOF

npx cucumber-js ${ROOT}/test/features/odata --tags "not @todo:embedded"

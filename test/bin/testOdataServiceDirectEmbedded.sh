#!/bin/bash

set -e
#set -x

TEST_DIR=./test/Vega

cd ${TEST_DIR}
WORK_DIR=`pwd`

export NODE_PATH=${WORK_DIR}/node_modules

#test -d node_modules && rm -r -f node_modules
#test -f package-lock.json && rm package-lock.json
#test -f db.sqlite && rm db.sqlite

test -d node_modules || npm i
test -f db.sqlite || npx cds deploy --to sqlite

npx cucumber-js ../../test/features/odata --tags "not @todo:embedded"

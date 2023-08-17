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
rm db.sqlite
test -f db.sqlite || npx cds deploy --to sqlite

# start service
PORT=7007 ./node_modules/.bin/cds run &
CDSPID=$!
echo "Started process with PID ${PID}"

# test
set +e
REMOTE_PORT=7007 npx cucumber-js ../../test/features/odata --tags "not @todo:remote"
RC=$?

# clean up
echo Terminate process with PID $CDSPID
kill -s SIGUSR2 $CDSPID

if [ $RC -ne 0 ]; then
  echo "Test failed, rc:${RC}"
  exit $RC
else
  echo "Test succeeded, rc:${RC}"
fi

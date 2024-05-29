#!/bin/bash

set -e
set -x

ROOT_DIR=`pwd`

WORK_DIR=${ROOT_DIR}/tmp/odata-v4-direct-remote

test -d $WORK_DIR && rm -r -f $WORK_DIR
test -d $WORK_DIR || mkdir -p $WORK_DIR

cd test/Vega

cp -v -r srv db _i18n .cdsrc.json .gitignore cucumber.yml package.json $WORK_DIR

cd $WORK_DIR

test -d node_modules || npm i
test -f db.sqlite && rm db.sqlite
test -f db.sqlite || npx cds deploy --to sqlite

# start service
PORT=7007 ./node_modules/.bin/cds run &
CDSPID=$!
echo "Started process with PID ${PID}"

# test
set +e

REMOTE_PORT=7007 npx cucumber-js ../../test/features/odata --tags "not @todo:remote" --fail-fast
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

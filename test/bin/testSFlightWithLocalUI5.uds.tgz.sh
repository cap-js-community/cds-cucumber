#!/bin/bash

set -x
set -e

ROOT_DIR=`pwd`
DIR=tmp/try-sflight-with-local-ui5-uds-tgz

. ./test/bin/.sapui5.version.sh
. ./test/bin/.sapui5.tgz.sh

#test -d $DIR && rm -r -f $DIR
test -d $DIR || mkdir -p $DIR
cd $DIR

test -d cap-sflight || git clone https://github.com/SAP-samples/cap-sflight.git --single-branch

cd cap-sflight

test -d node_modules || npm i
#test -d node_modules/sqlite3 || npm i -D sqlite3

if [ "$BRANCH_NAME" == "" ]; then
  test -d node_modules/@cap-js-community/cds-cucumber ||  npm i -D ../../..
else
  test -d node_modules/@cap-js-community/cds-cucumber ||  npm i -D git+https://github.com/cap-js-community/cds-cucumber.git#$BRANCH_NAME
fi

export CDS_CUCUMBER_PLUGIN_OVERWRITE="1"
#test -d local-ui5-tgz-plugin || 
npx cds-add-cucumber-plugin -p local-ui5-tgz -f app/travel_processor/webapp/index.html

test -f cucumber.yml || npx cds-add-cucumber

if [ "$BRANCH_NAME" == "" ]; then
cat <<EOF >cucumber.yml
default:
    require:
      - ../../../lib/index.js
EOF
fi

#test -d test/features/sflight || 
cp -r ${ROOT_DIR}/test/features/sflight test/features

export CDS_USERNAME=alice
export CDS_PASSWORD=admin

export SAP_UI5_MINOR_VERSION="${SAP_UI5_VERSION:0:5}"
export THREADS=$((`nproc --all` - 1))
export SAPUI5_UNIX_DOMAIN_SOCKET="${ROOT_DIR}/tmp/uds/$$"
echo "SAPUI5_UNIX_DOMAIN_SOCKET: ${SAPUI5_UNIX_DOMAIN_SOCKET}"
test -d ${ROOT_DIR}/tmp/uds || mkdir -p ${ROOT_DIR}/tmp/uds

pushd .
cd ${ROOT_DIR}/test/serveUI5 && npm i
popd
node ${ROOT_DIR}/test/serveUI5/index.js &
CDSPID=$!
echo "Started serveUI5 process with PID ${CDSPID}"

set +e
node ${ROOT_DIR}/test/serveUI5/waitForServer.js "${SAPUI5_UNIX_DOMAIN_SOCKET}"
RC=$?
if [ $RC -ne 0 ]; then
  echo "waitForServer failed, rc:${RC}"
  kill -s SIGTERM ${CDSPID}
  exit $RC
else
  echo "waitForServer succeeded, rc:${RC}"
fi

#export SHOW_BROWSER=1
#export SLOW_QUIT=1000
export ACCEPT_LANG=en

npx cucumber-js test/features/sflight --tags "not @todo and not @skip:node and not @skip:${SAP_UI5_MINOR_VERSION}" --parallel $THREADS
RC=$?
set -e

kill -s SIGTERM ${CDSPID}

echo "delete ${SAPUI5_UNIX_DOMAIN_SOCKET}"
test -d ${SAPUI5_UNIX_DOMAIN_SOCKET} && rm ${SAPUI5_UNIX_DOMAIN_SOCKET}

if [ $RC -ne 0 ]; then
  echo "Test failed, rc:${RC}"
  exit $RC
else
  echo "Test succeeded, rc:${RC}"
fi

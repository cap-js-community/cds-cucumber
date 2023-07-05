#!/bin/bash
set -e
set -x

ROOT=`pwd`

DIR=tmp/add-plugin

test -d ${DIR} && rm -r -f ${DIR}
mkdir -p ${DIR}
cd ${DIR}

npm init -y

npm init -w dk -y
npm i -w dk @sap/cds-dk

npm init -w service -y

cd service
rm package.json

npx cds init --add samples,sqlite && npx cds deploy --to sqlite
npm i @sap/cds
npm i express

node ${ROOT}/cds-plugins/addCdsPlugin.js -p just-exit

set +e
timeout -s SIGUSR2 5 npx cds run &
CHPID=$!

echo "Child pid: ${CHPID}"
wait ${CHPID}
RC=$?
echo "Child rc: ${RC}"

if [ $RC == 222 ]; then
  echo "Ok"
  exit 0
fi

if [ $RC == 124 ]; then
  echo "Timeout"
  exit 1
fi

echo "Failed: ${RC}"
exit 2
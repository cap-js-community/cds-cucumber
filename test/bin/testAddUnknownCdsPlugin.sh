#!/bin/bash
set -e

ROOT=`pwd`

DIR=tmp/add-unknown-plugin

test -d ${DIR} && rm -r -f ${DIR}
mkdir -p ${DIR}
cd ${DIR}

npm init -y

set +e
node ${ROOT}/cds-plugins/addCdsPlugin.js -p unknown-plugin
RC=$?
echo "Child rc: ${RC}"

if [ $RC == 1 ]; then
  echo "addCdsPlugin failed as expected"
  exit 0
fi

echo "Failed: ${RC}"
exit 2

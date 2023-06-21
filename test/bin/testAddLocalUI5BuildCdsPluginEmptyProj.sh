#!/bin/bash
set -e
set -x

ROOT=`pwd`

DIR=tmp/add-local-ui5-build-plugin-empty-proj

test -d ${DIR} && rm -r -f ${DIR}
mkdir -p ${DIR}
cd ${DIR}

npm init -y

node ${ROOT}/cds-plugins/addCdsPlugin.js -p local-ui5-build -f test.html

#!/bin/bash

set -e
set -x

DIR=tmp/getting-started

test -d $DIR && rm -r -f $DIR
test -d ${DIR} || mkdir -p $DIR
cd $DIR

npm init -y

npm init -w dk -y
npm add -w dk @sap/cds-dk

npm init -w service -y

cd service
rm package.json

npx cds init
npx cds add sample

if [ "$BRANCH_NAME" = "" ]; then
  npm add ../../.. || true
else
  npm add -D git+https://github.com/cap-js-community/cds-cucumber.git#$BRANCH_NAME
  #npm add -D https://github.com/cap-js-community/cds-cucumber/tarball/$BRANCH_NAME
fi
npx cds-add-cucumber

if [ "$BRANCH_NAME" = "" ]; then

cat <<EOF >cucumber.yml
default:
    require:
      - ../../../lib/index.js
EOF

fi

npx cucumber-js test

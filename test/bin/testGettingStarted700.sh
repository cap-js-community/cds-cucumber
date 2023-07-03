#!/bin/bash

set -e
set -x

DIR=tmp/getting-started-700

test -d $DIR && rm -r -f $DIR
test -d ${DIR} || mkdir -p $DIR
cd $DIR

npm init -y

npm init -w dk -y
npm i -w dk @sap/cds-dk@^7.0.0

npm init -w service -y

cd service
rm package.json

npx cds init --add samples,sqlite && npx cds deploy --to sqlite
npm i @sap/cds@^7.0.0
npm i express
if [ "$BRANCH_NAME" == "" ]; then
  npm i ../../.. || true
else
    npm i -D git+https://$TOKEN@github.com/cap-js-community/cds-cucumber.git#$BRANCH_NAME
    #npm i -D https://$TOKEN@github.com/cap-js-community/cds-cucumber/tarball/$BRANCH_NAME
fi
npx cds-add-cucumber

if [ "$BRANCH_NAME" == "" ]; then

cat <<EOF >cucumber.yml
default:
    publishQuiet: true
    require:
      - ../../../lib/index.js
EOF

fi

npx cucumber-js test

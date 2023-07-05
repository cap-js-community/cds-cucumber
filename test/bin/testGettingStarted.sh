#!/bin/bash

set -e
set -x

if [ "${CDS_VERSION}" = "" ]; then
  export CDS_VERSION="^7.0.0"
fi

CDS_VERSION_SHORT=${CDS_VERSION//[\^\~\.]/}
DIR=tmp/getting-started-${CDS_VERSION_SHORT}

test -d $DIR && rm -r -f $DIR
test -d ${DIR} || mkdir -p $DIR
cd $DIR

npm init -y

npm init -w dk -y
npm i -w dk @sap/cds-dk@${CDS_VERSION}

npm init -w service -y

cd service
rm package.json

npx cds init
if [ "${CDS_VERSION_SHORT::1}" = "6" ]; then
  npx cds add samples
else
  npx cds add sample
fi
npx cds add sqlite
npx cds deploy --to sqlite

npm i @sap/cds@${CDS_VERSION}
npm i express
if [ "$BRANCH_NAME" = "" ]; then
  npm i ../../.. || true
else
    npm i -D git+https://github.com/cap-js-community/cds-cucumber.git#$BRANCH_NAME
    #npm i -D https://github.com/cap-js-community/cds-cucumber/tarball/$BRANCH_NAME
fi
npx cds-add-cucumber

if [ "$BRANCH_NAME" = "" ]; then

cat <<EOF >cucumber.yml
default:
    publishQuiet: true
    require:
      - ../../../lib/index.js
EOF

fi

npx cucumber-js test

#!/bin/bash

set -e
set -x

DIR=tmp/getting-started-npm

test -d $DIR && rm -r -f $DIR
test -d ${DIR} || mkdir -p $DIR
cd $DIR

npm init -y

npm init -w dk -y
npm i -w dk @sap/cds-dk

npm init -w service -y

cd service
rm package.json

npx cds init
npx cds add sample
npx cds add sqlite
npx cds deploy --to sqlite

npm i @sap/cds
npm i express
npm i -D @cap-js-community/cds-cucumber
npx cds-add-cucumber

npx cucumber-js test

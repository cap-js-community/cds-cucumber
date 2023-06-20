#!/bin/bash
set -e
set -x
test -d tmp/getting-started && rm -r -f tmp/getting-started
mkdir -p tmp/getting-started
cd tmp/getting-started
npm init -y

npm init -w dk -y
npm i -w dk @sap/cds-dk

npm init -w service -y

cd service
rm package.json

npx cds init --add samples,sqlite && npx cds deploy --to sqlite
npm i @sap/cds
npm i express
npm i -D git+https://$TOKEN@github.com/cap-js-community/cds-cucumber.git#$BRANCH_NAME
#npm i -D https://$TOKEN@github.com/cap-js-community/cds-cucumber/tarball/$BRANCH_NAME
npx cds-add-cucumber
npx cucumber-js test

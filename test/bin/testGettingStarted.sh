#!/bin/bash
set -e
set -x
test -d tmp/getting-started && rm -r -f tmp/getting-started
mkdir -p tmp/getting-started
cd tmp/getting-started
npm init -y
npm i @sap/cds-dk
rm package.json package-lock.json
npx cds init --add samples,sqlite && npx cds deploy --to sqlite
npm i @sap/cds
npm i express
npm i git+https://$TOKEN@github.com/cap-js/cds-cucumber-fe.git#$BRANCH_NAME
npx cds-add-cucumber-fe
npx cucumber-js test

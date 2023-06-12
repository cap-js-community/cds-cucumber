#!/bin/bash
set -e
set -x
test -d tmp/getting-started-local && rm -r -f tmp/getting-started-local
mkdir -p tmp/getting-started-local
cd tmp/getting-started-local
npm init -y

npm init -w dk -y
npm i -w dk @sap/cds-dk

npm init -w service -y
cd service
rm package.json

npx cds init --add samples,sqlite && npx cds deploy --to sqlite
npm i @sap/cds
npm i express
npm i ../../.. || true
npx cds-add-cucumber
# requireModule does not work with links -> require the steps directly
cat <<EOF >cucumber.yml
default:
    publishQuiet: true
    require:
      - ../../../lib/index.js
EOF
npx cucumber-js test

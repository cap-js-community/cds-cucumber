#!/bin/bash
set -e
set -x
test -d tmp/getting-started-local && rm -r -f tmp/getting-started-local
mkdir -p tmp/getting-started-local
cd tmp/getting-started-local
npm init -y
npm i @sap/cds-dk
rm package.json package-lock.json
npx cds init --add samples,sqlite && npx cds deploy --to sqlite
npm i @sap/cds
npm i express
npm i ../..
npx cds-add-cucumber-fe
# requireModule does not work with links -> require the steps directly
cat <<EOF >cucumber.yml
default:
    publishQuiet: true
    require:
      - ../../lib/index.js
EOF
npx cucumber-js test

#!/bin/bash
set -e
set -x
DIR=tmp/getting-started-locally-with-local-ui5
test -d $DIR && rm -r -f $DIR
mkdir -p $DIR
cd $DIR
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

npx cds-add-cucumber-plugin -p local-ui5-build

cat <<EOF >.cdsrc.json
{
  "preview": {
    "ui5": {
      "host":"/"
    }
  }
}
EOF

npx cucumber-js test

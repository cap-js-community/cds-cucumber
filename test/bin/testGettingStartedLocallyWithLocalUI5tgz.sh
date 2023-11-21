#!/bin/bash
set -e
set -x

ROOT_DIR=`pwd`
DIR=tmp/getting-started-locally-with-local-ui5-tgz
test -d $DIR && rm -r -f $DIR
mkdir -p $DIR
cd $DIR
npm init -y

npm init -w dk -y
npm add -w dk @sap/cds-dk

npm init -w service -y
cd service
rm package.json

npx cds init --add sample
npm add ../../.. || true
test -f ./.vscode/extensions.json && rm ./.vscode/extensions.json
npx cds-add-cucumber
# requireModule does not work with links -> require the steps directly
cat <<EOF >cucumber.yml
default:
    require:
      - ../../../lib/index.js
EOF

. ${ROOT_DIR}/test/bin/.sapui5.version.sh
. ${ROOT_DIR}/test/bin/.sapui5.tgz.sh
if [ -f ${SAPUI5_ARCHIVE_FILE} ]; then
  echo "Found UI5 local archive: ${SAPUI5_ARCHIVE_FILE}"
else
  echo "Could not find UI5 local archive"
  exit 1
fi

npx cds-add-cucumber-plugin -p local-ui5-tgz -f ./app/index.html

npx cucumber-js test

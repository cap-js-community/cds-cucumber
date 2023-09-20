#!/bin/bash

set -e
set -x

if [ "${CDS_VERSION}" = "" ]; then
  export CDS_VERSION="^7.0.0"
fi
CDS_VERSION_SHORT=${CDS_VERSION//[\^\~\.]/}

if [ "${CDS_ADD_SAMPLE_COMMAND}" = "" ]; then
  if [ "${CDS_VERSION_SHORT::1}" = "6" ]; then
    CDS_ADD_SAMPLE_COMMAND="samples"
  else
    CDS_ADD_SAMPLE_COMMAND="sample"
  fi
fi

DIR=tmp/getting-started-${CDS_VERSION_SHORT}-${CDS_ADD_SAMPLE_COMMAND}

test -d $DIR && rm -r -f $DIR
test -d ${DIR} || mkdir -p $DIR
cd $DIR

npm init -y

npm init -w dk -y
npm add -w dk @sap/cds-dk@${CDS_VERSION}

npm init -w service -y

cd service
rm package.json

npx cds init
npx cds add ${CDS_ADD_SAMPLE_COMMAND}

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

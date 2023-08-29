#!/bin/bash

# Step 'When we select tile "Manage Orders"' fails in case the .cds-services.json contains inactive OrdersService

set -x
set -e

. ./test/bin/.sapui5.version.sh

ROOT_DIR=`pwd`
DIR=tmp/try-bookshop-with-local-ui5-plugin-error-page

#test -d $DIR && rm -r -f $DIR
test -d $DIR || mkdir -p $DIR
cd $DIR
TEST_DIR=`pwd`

test -d cloud-cap-samples || git clone https://github.com/SAP-samples/cloud-cap-samples.git --single-branch

cd cloud-cap-samples

test -d node_modules || npm i
test -d node_modules/sqlite3 || npm i -D sqlite3

if [ "$BRANCH_NAME" == "" ]; then
  test -d node_modules/@cap-js-community/cds-cucumber ||  npm i -D ../../..
else
  test -d node_modules/@cap-js-community/cds-cucumber ||  npm i -D git+https://github.com/cap-js-community/cds-cucumber.git#$BRANCH_NAME
fi

. ${ROOT_DIR}/test/bin/.sapui5.dist.dir.sh
if [ -d ${SAPUI5_DIST_DIRECTORY} ]; then
  echo "Found UI5 local build: ${SAPUI5_DIST_DIRECTORY}"
else
  echo "Could not find UI5 local build"
  exit 1
fi

test -d local-ui5-build-plugin || npx cds-add-cucumber-plugin -p local-ui5-build -w fiori -f app/fiori-apps.html

test -f cucumber.yml || npx cds-add-cucumber

if [ "$BRANCH_NAME" == "" ]; then
cat <<EOF >cucumber.yml
default:
    require:
      - ../../../lib/index.js
EOF
fi

test -f test/features/bookshop || cp -r ../../../test/features/bookshop test/features

export CDS_SERVICE_APPLICATION=fiori
export CDS_COMMAND_ARG1="--with-mocks"
export CDS_COMMAND_ARG2="--in-memory?"

export CDS_USERNAME=alice
export CDS_PASSWORD=admin

export CDS_CUCUMBER_WORKING_DIRECTORY=${TEST_DIR}/work_dir
test -d ${CDS_CUCUMBER_WORKING_DIRECTORY} || mkdir -p ${CDS_CUCUMBER_WORKING_DIRECTORY}
CDS_SERVICES_FILE=${CDS_CUCUMBER_WORKING_DIRECTORY}/.cds-services.json

cat <<EOF >${CDS_SERVICES_FILE}
{
  "cds": {
    "provides": {
      "OrdersService": {
        "kind": "odata",
        "credentials": {
          "url": "http://localhost:999/odata/v4/orders"
        }
      },
      "ReviewsService": {
        "kind": "odata",
        "credentials": {
          "url": "http://localhost:999/reviews"
        }
      }
    }
  }
}
EOF

touch ${CDS_SERVICES_FILE}.lock

#rm -f ${CDS_SERVICES_FILE}

npx cucumber-js test/features/bookshop/modify/create.order.item.feature

# Fails as expected:
#  ✖ When we select tile "Manage Orders" # ../../../lib/steps/navigation.js:37
#       Error: Found unexpected error message: {"description":"Could not load metadata: 404 Not Found","title":"Application could not be started due to technical issues."}
#           at World.<anonymous> (/home/vl-leon/workspace/cds-cucumber/lib/steps/navigation.js:42:11)

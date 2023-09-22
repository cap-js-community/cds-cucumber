#!/bin/bash

if [ -z "${SAP_UI5_VERSION}" ]; then
  echo "SAP_UI5_VERSION is not set"
  exit 1
fi

FILE_CANDIDATE=${ROOT_DIR}/tmp/sapui5/sapui5-${SAP_UI5_VERSION}.tgz
if [ -f ${FILE_CANDIDATE} ]; then
  export SAPUI5_ARCHIVE_FILE=${FILE_CANDIDATE}
  echo "Found UI5 local archive: ${SAPUI5_ARCHIVE_FILE}"
fi

FILE_CANDIDATE=${ROOT_DIR}/../sapui5/sapui5-${SAP_UI5_VERSION}.tgz
if [ -f ${FILE_CANDIDATE} ]; then
  export SAPUI5_ARCHIVE_FILE=${FILE_CANDIDATE}
  echo "Found UI5 local archive: ${SAPUI5_ARCHIVE_FILE}"
fi

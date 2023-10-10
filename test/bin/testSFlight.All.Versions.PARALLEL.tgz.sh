#!/bin/bash
for dir in ls ./tmp/sapui5/sapui5-*.tgz
do
  VERSION="${dir:20:7}"
  if [ -n "${VERSION}" ]; then
    NOW=`date +%d.%m.%Y-%H.%M.%S`
    LOGFILENAME="/tmp/cds-cucumber-${VERSION}-${NOW}.log"
    echo "test ${VERSION} ${LOGFILENAME}"
    SAP_UI5_VERSION=${VERSION} test/bin/testSFlightWithLocalUI5.uds.tgz.sh &> ${LOGFILENAME}
    echo $?
  fi
done

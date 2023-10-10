#!/bin/bash
for dir in ls ./tmp/sapui5/full*
do
  VERSION="${dir:18}"
  if [ -n "${VERSION}" ]; then
    NOW=`date +%d.%m.%Y-%H.%M.%S`
    LOGFILENAME="/tmp/cds-cucumber-${VERSION}-${NOW}.log"
    echo "test ${VERSION} ${LOGFILENAME}"
    SAP_UI5_VERSION=${VERSION} test/bin/testSFlightWithLocalUI5plugin.PARALLEL.sh &> ${LOGFILENAME}
    echo $?
  fi
done

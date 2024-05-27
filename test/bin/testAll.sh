#!/bin/bash

set -e
set -x

# getting started
test/bin/testGettingStartedReuseUI5LocalBuild.sh
test/bin/testBookshopWithLocalUI5plugin.ODATA.sh
test/bin/testBookshopWithLocalUI5plugin.PARALLEL.sh

# SFlight
test/bin/testSFlightWithLocalUI5plugin.sh
test/bin/testSFlightWithLocalUI5plugin.PARALLEL.sh

test/bin/testODataServiceCopy.sh
test/bin/testODataV2GettingStartetAnnotated.sh
test/bin/testODataV4GettingStartet.sh
test/bin/testODataV2GettingStartet.sh
test/bin/testODataServiceDirectEmbedded.sh
test/bin/testODataV4DirectRemote.sh

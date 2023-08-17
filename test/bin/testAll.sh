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

test/bin/testOdataServiceCopy.sh
test/bin/testOdataServiceDirectEmbedded.sh
test/bin/testOdataServiceDirectRemote.sh

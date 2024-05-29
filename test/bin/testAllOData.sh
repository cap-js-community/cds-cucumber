#!/bin/bash

set -e
set -x

test/bin/testODataServiceCopy.sh
test/bin/testODataV2GettingStartetAnnotated.sh
test/bin/testODataV4GettingStartet.sh
test/bin/testODataV2GettingStartet.sh
test/bin/testODataServiceDirectEmbedded.sh
test/bin/testODataV4DirectRemote.sh

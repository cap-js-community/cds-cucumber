#!/bin/bash

set -e
set -x

node ./test/utils/checkAPI.js
node ./test/utils/checkJsDoc.js
node ./test/utils/checkRequires.js

#!/bin/bash
set -x
echo "---------------- init.sh ----------------"
pwd

npm i @ui5/cli
npx ui5 build preload --include-task generateVersionInfo --all

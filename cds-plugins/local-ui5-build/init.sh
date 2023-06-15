#!/bin/bash
set -x
echo "---------------- init.sh ----------------"
pwd

npm init -w ui5cli -y
npm i -w ui5cli @ui5/cli

npx ui5 build preload --include-task generateVersionInfo --all

#!/bin/bash
args="$@"
set -x
echo "---------------- init.sh ----------------" $args
pwd

npm i @ui5/cli
####npx ui5 build preload --include-task generateVersionInfo --all
npx ui5 build self-contained --all --include-task generateVersionInfo

DIR=`pwd`
pushd .
cd $TARGET_DIR
node $DIR/init.js $args
popd

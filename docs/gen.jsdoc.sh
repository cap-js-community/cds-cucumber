#!/bin/bash
set -e
set -x
test -d tmp/jsdoc || mkdir -p tmp/jsdoc

pushd .

cd tmp/jsdoc
npm init -y
npm i foodoc
npm i jsdoc@3.6.11

npx jsdoc -c ../../docs/jsdoc.config.json -t ./node_modules/foodoc/template -R ../../README.md -r ../../lib/steps -d ./out

popd

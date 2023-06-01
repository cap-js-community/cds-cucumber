#!/bin/bash

set -e
set -x
test -d tmp/jsdoc || mkdir -p tmp/jsdoc

pushd .

cd tmp/jsdoc
npm init -y
npm i foodoc
npm i jsdoc@3.6.11

npx jsdoc -c ../../docs/scripts/jsdoc.config.json -t ./node_modules/foodoc/template -R ../../docs/README.md -r ../../lib/steps -d ../../docs -p ../../package.json

for f in ../../docs/*.md; do
  fh="../../docs/${f:11:-3}.html"
  npx showdown makehtml -i ${f} -o ${fh}
done

popd

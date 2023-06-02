#!/bin/bash

set -e
set -x

test -d tmp/jsdoc  || mkdir -p tmp/jsdoc

pushd .
cd tmp/jsdoc

if [ -f package.json ]; then
  echo Already initialized.
else
  npm init -y
  npm i foodoc
  npm i jsdoc@3.6.11
fi

npx jsdoc -c ../../docs/scripts/jsdoc.config.json -t ./node_modules/foodoc/template -R ../../docs/README.md -r ../../lib/steps -d ../../docs -p ../../package.json

for f in ../../docs/*.md; do
  fh="../../docs/${f:11:-3}.html"
done

popd

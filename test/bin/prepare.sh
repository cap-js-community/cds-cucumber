#!/bin/bash

test -d tmp || mkdir tmp
cd tmp

test -d cloud-cap-samples || git clone https://github.com/SAP-samples/cloud-cap-samples.git --single-branch
pushd .
cd cloud-cap-samples && npm i sqlite3
popd

test -d cap-sflight || git clone https://github.com/SAP-samples/cap-sflight.git --single-branch
pushd .
cd cap-sflight && npm i
popd

#!/bin/bash

export TEST_USER=alice
export TEST_PASSWORD=admin
export TEST_SERVICE_DIR=tmp/cap-sflight
npx cucumber-js test/features/sflight/travel.count.feature

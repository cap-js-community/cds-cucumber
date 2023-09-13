@echo off

setlocal

cd tmp/cap-sflight

set CDS_USERNAME=alice
set CDS_PASSWORD=admin

set ACCEPT_LANG=en

call npx cucumber-js ..\..\test\features\sflight --tags "not @todo and not @skip:node"

endlocal

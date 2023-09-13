@echo off

setlocal

cd tmp\cloud-cap-samples\fiori

set CDS_COMMAND_ARG1=--with-mocks
set CDS_COMMAND_ARG2=--in-memory?

set ACCEPT_LANG=en

call npx cucumber-js ..\..\..\test\features\bookshop --tags "not @todo"

endlocal

@echo off

setlocal

set CDS_COMMAND_ARG1=--with-mocks
set CDS_COMMAND_ARG2=--in-memory?

cd tmp\cloud-cap-samples\fiori

call npx cucumber-js ..\..\..\test\features\bookshop --tags "not @todo"

endlocal

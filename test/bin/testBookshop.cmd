@echo off

setlocal

cd tmp\cloud-cap-samples\fiori

set CDS_COMMAND_ARG1=--with-mocks
set CDS_COMMAND_ARG2=--in-memory?

set ACCEPT_LANG=en

rem set ENABLE_CORS=1
rem set SHOW_BROWSER=1
rem set SLOW_QUIT=1000

call node ..\..\..\cds-plugins\addCdsPlugin.js -p local-ui5-tgz -f app/fiori-apps.html

set SAPUI5_ARCHIVE_FILE=..\..\..\..\sapui5\sapui5-1.118.0.tgz
call npx cucumber-js ..\..\..\test\features\bookshop --tags "not @todo" --parallel 8

endlocal

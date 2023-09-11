rem @echo off

setlocal

set "ROOT_DIR=%cd%"

pushd %~dp0

cd %ROOT_DIR%\test\Vega

call npm i

if exist db.sqlite del db.sqlite

call npx cds deploy --to sqlite

call npx cucumber-js %ROOT_DIR%\test\features\odata --tags "not @todo:embedded"

popd

endlocal

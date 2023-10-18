# Local SAP UI5

Hosting SAP UI5 locally is beneficial due to the following reasons:
* reduce CO2 emissions
* improve first test load time otherwise it could fail with timeout
* switch UI5 versions easily
* reduce network load
* run tests off-line
* utilize [CI caches](https://docs.github.com/en/enterprise-server@3.8/actions/using-workflows/caching-dependencies-to-speed-up-workflows#managing-caches) to reduce the test duration

Using [ui5 tools](https://sap.github.io/ui5-tooling/) helps to build local UI5 that consists of all files required by the UI application.

The local UI5 build will be performed using the following command sequence:
```
npm i @ui5/cli
npx ui5 use sapui5@1.118.1
npm version "1.118.1"
npx ui5 build self-contained --all --include-task generateVersionInfo
```

In order to use the ready UI5 builds, the cds-cucumber module provides the following cds plugins:
* local-ui5-tgz - serve tgz archived UI5 version
* local-ui5-build - serve the *dist* directory of a UI5 local build

In order to activate one of the plugins you can use the following command:

```npx cds-add-cucumber-plugin -p <plugin name> <options>```

Options:
* -w \<workspace\> (optional) specifies the target nodejs workspace
* -f \<filename\> (optional) specifies the html file to be modified so that it utilizes the local UI5 version

Examples:

* Bookshop

```npx cds-add-cucumber-plugin -p local-ui5-tgz -w fiori -f app/fiori-apps.html```

* SFlight

```npx cds-add-cucumber-plugin -p local-ui5-tgz -f app/travel_processor/webapp/index.html```

The repository provides shell scripts that help to perform the UI5 build but they are are not part of the released module.
The scripts uses the *tmp/sapui5* directory relative to the current directory.
You can create a symlink if you want to target another build target directory.

## Serving archived version (tgz file)
* reason - virus scanner handles better one single file
* build with the following command:

```test/bin/build.ui5.tgz.sh```

* enable with the following command:

```npx cds-add-cucumber-plugin -p local-ui5-tgz -w fiori -f app/fiori-apps.html```

## Serving build directory
* build with the following command:

```test/bin/build.ui5.sh```
* enable with the following command:

```npx cds-add-cucumber-plugin -p local-ui5-build -w fiori -f app/fiori-apps.html```

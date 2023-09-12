# Serve static SAP UI5 resources

The module will locate automatically a local SAP UI5 build in the following folders:
- {current directory}
- {cds-cucumber}/tmp/sapui5/full-{version}/dist
- {cds-cucumber}/../sapui5/full-{version}/dist

The SAP UI5 version will be obtained automatically from the following file:
- {cds-cucumber}/test/bin/.sapui5.version.sh

## Usage
- directly:
```
node test/staticUI5/index.js
```

- change the directory:
```
cd test/staticUI5 && npm start
```

- use another port where 8888 is the default
```
PORT=8080 node test/staticUI5/index.js
```

- use another hostname where 'localhost' is the default
```
HOSTNAME=127.0.0.1 node test/staticUI5/index.js
```

- use custom SAP UI5 directory
```
SAPUI5_DIST_DIRECTORY=~/sapui5/1.234.5/dist npm start
```

- use custom SAP UI5 version
```
SAP_UI5_VERSION=1.117.1 npm start
```
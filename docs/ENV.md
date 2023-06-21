# Environment variables

## Authentication

### CDS_USERNAME

Specifies the name of the user to login with.

### CDS_PASSWORD

Specifies the password to use for authentication.

## Service control

### REMOTE_HOSTNAME

Specifies the hostname of the target service.

### REMOTE_PORT

Specifies the port of the target service.

### CDS\_SERVICE\_PORT

Specifies the port for the cds service to listen to.

### CDS_STACK

Specifies the programming stack to use: node or java, default: node.
Depending on the specified value the framework will start the CDS service with the following command:

 * for Nodejs:
 
    ```npx cds-serve```

 * for java:

    ```mvn clean spring-boot:run```

Example:
```
CDS_STACK=java
```

### CDS_COMMAND

Specifies the command to pass to npx.

* default: cds-serve

### CDS\_SERVICE\_DIRECTORY

Specifies the root directory of the cds service.
The cds service will be started in the specified directory by setting it as a current working directory.

Example:
```
CDS_SERVICE_DIRECTORY=tmp/cloud-cap-samples
```

### CDS\_SERVICE\_APPLICATION

Specifies the subdirectory of the cds service by appending it to the service root directory.

Example:
```
CDS_SERVICE_APPLICATION=fiori
```

### CDS\_ENABLE\_LOCAL\_UI5\_VERSION

Enables the default Fiori Preview page to load local UI5 version by setting the CDS_CONFIG to ```{"preview": {"ui5": { "host": "/" } } }``` but does not overwrite it.

Example:
```
CDS_ENABLE_LOCAL_UI5_VERSION=1
```

## Execution control

### SLOW_DOWN

Specifies the number of seconds to wait between the single operations.

Example:
```
SLOW_DOWN=1
```

## Browser control

### SHOW_BROWSER

Controls the visibility of the browser. By default it is invisible as it is started in headless mode.

Example:
```
SHOW_BROWSER=1
```

### SLOW_QUIT

Specifies the number of seconds to sleep before closing the browser.

Example:
```
SLOW_QUIT=2
```

## Debbuging UI

### CDS\_CUCUMBER\_DEBUG

Used to increase the steps default timeout during debugging sessions and load the steps-browser-library via the webserver instead of injecting it.

Example:
```
CDS_CUCUMBER_DEBUG=1
```

### CDS\_CUCUMBER\_LIB\_URL

Specifies the path to the steps-library (browser.js) to be loaded during UI debugging sessions.

* default: /browser.js

### BROWSER\_DEBUGGING\_PORT

Specifies the remote debugging port of the browser. It is used when debugging the SAP UI5 code.

* default value: 9222

### CDS\_CUCUMBER\_WAIT\_DEBUGGER

Forces the initialization process to wait until the debugger is attached.

Example:
```
CDS_CUCUMBER_WAIT_DEBUGGER=1
```

## Code coverage

Used module: istanbul

### CDS\_INSTRUMENTED\_CODECOV\_BROWSER\_EXT

Specifies the instrumented code used for producing a code coverage report.

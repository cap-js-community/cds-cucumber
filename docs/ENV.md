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

### CDS_COMMAND

Specifies the command to pass to the cds command.

* default: run
* watch-mode: watch

Example:
```
CDS_COMMAND=watch
```
The resulting command is: npx cds watch

### REPLACE_PAGE
experimental

### REPLACE_PREFIX
experimental

### SAP\_UI5\_VERSION
experimental

### CDS_STACK

Specified the programming stack to use: node or java, default: node

 * node command: "npx cds run"

 * java command: "mvn clean spring-boot:run"

Example:
```
CDS_STACK=java
```

### CDS\_SERVICE\_DIR

Specifies the root directory of the cds service.
The cds service will be started in the specified directory by setting it the the current working directory.

Example:
```
CDS_SERVICE_DIR=fiori
```

## Browser control

### SLOW_QUIT

Specifies the number of secconds to sleep before closing the browser.

Example:
```
SLOW_QUIT=2
```

### SLOW_DOWN

Specifies the number of secconds to wait between the single operations.

Example:
```
SLOW_DOWN=1
```

### SHOW_BROWSER

The browser is by default in headless mode and with this variable it can become visible

Example:
```
SHOW_BROWSER=1
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

### REMOTE\_DEBUGGING\_PORT

Specifies the remote debugging port of the browser and important when debugging the SAP UI5 code.

* default value: 9222

### CDS\_CUCUMBER\_WAIT\_DEBUGGER

Forces the initialization process to wait until the debugger is attached

Example:
```
CDS_CUCUMBER_WAIT_DEBUGGER=1
```

## Code coverage

Used library: instambul

### INSTRUMENTED_CODE

Specifies the instrumented code used for producing a code coverage report.
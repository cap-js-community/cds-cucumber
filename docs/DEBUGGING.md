# Debugging

The following document describes how to debug the step-implementations, server-side (CDS Node.js Runtime) and browser code (SAP UI5 and the steps browser extension: browser.js) using VSCode.

## Steps

Debugging the step-implementations with VSCode is possible in two ways.

### VSCode JavaScript Debug Terminal

Use the following command to start javascript debug terminal:
Keyboard-shortcut: *Ctrl+Shift+P*
Command: *Debug: JavaScript Debug Treminal*

Now you can add breakpoints in the steps code and start the tests in the new terminal tab.

### Launch target configuration

File: ./.vscode/launch.json

```
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "SFlight Features",
      "type": "node",
      "request": "launch",
      "program": "npx",
      "args": ["cucumber-js","test/features/sflight"],
      "env": {
        "CWD": "${workspaceFolder}",
        "CDS_USERNAME": "alice",
        "CDS_PASSWORD": "admin",
        "CDS_SERVICE_DIR": "tmp/cap-sflight",
        "CUCUMBER_PUBLISH_ENABLED": "false",
        "CUCUMBER_PUBLISH_QUIET": "true"
      },
      "skipFiles": [
        "<node_internals>/**"
      ],
      "outputCapture": "console",
      "console": "integratedTerminal"
    }
  ]
}
```

Add breakpoints in the steps code and run the new target in the "Run and Debug" tab of VSCode.
You can add additional cucumber-js arguments as you wish, and also change the environment variables to values applicable for your project.

## Server-side

This section describes the possibilities to debug the CDS Node.js Runtime.
The CDS Server will be started as a new process via the provided steps.
In order to debug the code, you can follow the same procedure as for the [Steps](#steps) then you can add breakpoints in the CDS Nodejs Runtime code.

## Browser

VSCode offers attaching to and debugging of browser sessions.
Add a new launch configuration as follows:

File: ./.vscode/launch.json

```
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "chrome",
      "name": "Bookshop: Attach to browser",
      "request": "attach",
      "port": 9222,
      "webRoot": "${workspaceFolder}/tmp/cloud-cap-samples/fiori/app",
      "urlFilter": "http://localhost:4004/*"
    }
  ]
}
```

Description of the parameters:
- port - browser debugger port to attach to, configurable via enviromnent variable [BROWSER\_DEBUGGING\_PORT](ENV.md#browser_debugging_port).
- webRoot - webserver root directory containing root folder webpages
- urlFilter - filter to help locating the webpage to attach to.
The port 4004 is the default port of the CDS Server when running standalone.
The CDS Server obtains a random port when started via the cds-cucumber library, 
but can be changed to a fixed one via the environment variable [CDS\_SERVICE\_PORT](ENV.md#cds_service_port).

When the tests are started with debugging enabled via [CDS\_CUCUMBER\_DEBUG](ENV.md#cds_cucumber_debug), the CDS server is running, selenuim is initialized and the step-library is loaded into the browser, the execution of the steps will wait until the VSCode Debugger is attached to the browser session but only in case the environment variable [CDS\_CUCUMBER\_WAIT\_DEBUGGER](ENV.md#cds_cucumber_wait_debugger) is set.

# Detailed information

## Initialization

Initialization of the steps library is triggered via the command:
```
npx cds-add-cucumber
```

It will perform the following operations:
1. create cucumber configuration file ./cucumber.yml containing the following settings:
    - **require** steps module
    ```yaml
    default:
        requireModule:
          - "@cap-js-community/cds-cucumber"
    ```
1. create directory for feature specifications: ./test/features
1. create directory for own steps: ./test/features/step_definitions
1. optionally (in case the project matches the **cds samples** one) create first feature file: ./test/features/first.feature
1. create configuration for [cucumber plugin](#vscode-cucumbergherkin-plugin): ./.vscode/settings.json
    ```json
    {
      "cucumberautocomplete.steps": [
        "test/features/step_definitions/*.js",
        "node_modules/@cap-js-community/cds-cucumber/lib/steps/*.js"
      ],
      "cucumberautocomplete.strictGherkinCompletion": true
    }
    ```
1. optionally (in case the project matches the **cds samples** one) create file with CDS annotations: ./srv/annotations.cds

## Add your own steps

In addition to the provided steps you can add your own steps in your repository.
By default they should be located in the following folder:

```
test/features/step_definitions
```

## VSCode Cucumber(Gherkin) plugin

In order to get support (like code completion) for VSCode while writing your specifications, you can install one of the following plugins:

* [Cucumber for Visual Studio Code (CucumberOpen)](https://open-vsx.org/extension/CucumberOpen/cucumber-official)

  Default configuration in file:

  .vscode/settings.json

  ```
  {
    "cucumber.features": [
      "test/features/**/*.feature"
    ],
    "cucumber.glue": [
      "test/features/step_definitions/**/*.js",
      "node_modules/@cap-js-community/cds-cucumber/lib/steps/*.js"
    ]
  }
  ```

* [Cucumber (Gherkin) Full Support](https://marketplace.visualstudio.com/items?itemName=alexkrechik.cucumberautocomplete)


  Default configuration in file:

  .vscode/settings.json

  ```
  {
    "cucumberautocomplete.steps": [
      "test/features/step_definitions/*.js",
      "node_modules/@cap-js-community/cds-cucumber/lib/steps/*.js"
    ],
    "cucumberautocomplete.strictGherkinCompletion": true
  }
  ```


## Debugging

Information can be found [here](DEBUGGING.md).

## Environment variables

Information can be found [here](ENV.md).

## Information about the used webdriver

The selenium-webdriver nodejs module is used to control the browser and it requires a webdriver. The version of the webdriver should match the version of the web browser. The node module [chromedriver](https://www.npmjs.com/package/chromedriver) is used to download the latest webdriver version automatically. Both modules are listed in the dependencies of this module.

Most systems are configured to update the browser automatically which requires also an update of the webdriver.
You can update the chrome webdriver to the latest version with the following command:
```
npm install chromedriver --chromedriver_version=LATEST
```

## Selenium in docker

In cases where the browser is not installed or can not be started (CI),
you can run selenium and the corresponding browser in docker as follows:

- start selenium docker container

```
docker run -d --network host selenium/standalone-chrome
```

By default the selenium/standalone-chrome image opens the port 4444 to access the webdriver.

- start the tests passing the selenium remote url as an environment variable:

```
SELENIUM_REMOTE_URL="http://127.0.0.1:4444/wd/hub" npx cucumber-js test
```

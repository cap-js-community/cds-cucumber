# CDS Cucumber FE

Provides a library to write behaviour-driven tests for CAP applications and SAP Fiori Elements.
It contains ready-to-use steps that help developers write tests in a BDD style.
The [cucumber](https://cucumber.io) project provides framework for that.

It would look like that:
```gherkin
Feature: Fiori preview page

  Scenario: Open first Fiori preview page
    Given we have started the CAP application
      And we have opened the url "/"
    When we click on first Fiori preview page
      And we search for "jane"
    Then we expect to have 1 table records
```

The project is in early **beta phase**, please expect changes.

## API

List of steps and details is available in the [API documentation](https://cap-js.github.io/cds-cucumber-fe/list_namespace.html).

## Usage

Make sure you have a CAP project or create a new one with the following command,
which requires global installation of the [CAP development toolkit](https://cap.cloud.sap/docs/get-started/jumpstart#setup): *npm i -g @sap/cds-dk*
```
npx cds init --add samples,sqlite && npx cds deploy --to sqlite
```

In addition the latest version of the **chrome browser** should be present on the system.

### Install

**TODO** replace with npm i cds-cucumber-fe
```
npm i -D git+https://github.com/cap-js/cds-cucumber-fe.git
```

### Configure

```
npx cds-add-cucumber-fe
```

### Add feature files

File: test/features/first.feature
```gherkin
Feature: Fiori preview page

  Scenario: Open first Fiori preview page
    Given we have started the CAP application
      And we have opened the url "/"
    When we click on first Fiori preview page
      And we search for "jane"
    Then we expect to have 1 table records
```

For existing projects you have to adjust the example above.

### Validate features

```
npx cucumber-js test
```

## More

For additional information see the [details](DETAILS.html) page.

# CDS for Cucumber

Provides a library to write behaviour-driven tests for CAP applications.
It contains ready-to-use steps that help developers write tests in a BDD style.
The [cucumber](https://cucumber.io) project provides framework for that.
Currently the library supports SAP Fiori® Elements.

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

List of steps and details is available in the [API documentation](https://cap-js-community.github.io/cds-cucumber/list_namespace.html).

## Usage

Make sure you have a CAP project or create a new one with the following command,
which requires global installation of the [CAP development toolkit](https://cap.cloud.sap/docs/get-started/jumpstart#setup): *npm i -g @sap/cds-dk*
```
npx cds init --add samples,sqlite && npx cds deploy --to sqlite
```

In addition the latest version of the **chrome browser** should be present on the system.

### Install

```
npm i -D @cap-js-community/cds-cucumber
```


### Configure

```
npx cds-add-cucumber
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

For additional information see the [details](docs/DETAILS.md) page.

## Support, Feedback, Contributing

This project is open to feature requests/suggestions, bug reports etc. via [GitHub issues](https://github.com/cap-js-community/cds-cucumber/issues). Contribution and feedback are encouraged and always welcome. For more information about how to contribute, the project structure, as well as additional contribution information, see our [Contribution Guidelines](CONTRIBUTING.md).

## Code of Conduct

We as members, contributors, and leaders pledge to make participation in our community a harassment-free experience for everyone. By participating in this project, you agree to abide by its [Code of Conduct](CODE_OF_CONDUCT.md) at all times.

## Licensing

Copyright 2022 SAP SE or an SAP affiliate company and cds-cucumber contributors. Please see our [LICENSE](LICENSE) for copyright and license information. Detailed information including third-party components and their licensing/copyright information is available [via the REUSE tool](https://api.reuse.software/info/github.com/cap-js-community/cds-cucumber).

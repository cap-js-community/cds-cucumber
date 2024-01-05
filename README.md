# CDS for Cucumber

Provides a library for behaviour-driven tests of CAP applications.
It contains ready-to-use steps that help you write tests in a BDD style.
The [cucumber](https://cucumber.io) project provides framework for that.

As of now, the library supports SAP Fiori® Elements as UI framework and OData as communication protocol.

A typical test looks like this:

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

## Documentation

List of steps and details is available in the [documentation](https://cap-js-community.github.io/cds-cucumber/list_namespace.html).

## Usage

### Setup

Install the [CAP development toolkit](https://cap.cloud.sap/docs/get-started/jumpstart#setup):

```sh
npm add -g @sap/cds-dk
```

### Create a project

Make sure you have a CAP project. You can create one with the following command:

```sh
cds init --add sample bookshop
cd bookshop
```

### Configure

```sh
npm add -D @cap-js-community/cds-cucumber
npx cds-add-cucumber
```

### Add feature files

File: test/features/first.feature
```gherkin
Feature: Bookshop first feature file

  Scenario: Open "Manage Books" as "alice" and search for "jane"
    Given we have started the CAP application
      And we have opened the url "/" with user "alice"
    When we select tile "Manage Books"
      And we search for "jane"
    Then we expect to have 2 table records
```

For existing projects you have to adjust the example above.

### Run feature tests

```
npx cucumber-js test
```

A recent version of the **chrome browser** should be present on the system.


## More

For additional information see the [details](docs/DETAILS.md) page.

## Support, Feedback, Contributing

This project is open to feature requests/suggestions, bug reports etc. via [GitHub issues](https://github.com/cap-js-community/cds-cucumber/issues). Contribution and feedback are encouraged and always welcome. For more information about how to contribute, the project structure, as well as additional contribution information, see our [Contribution Guidelines](CONTRIBUTING.md).

## Code of Conduct

We as members, contributors, and leaders pledge to make participation in our community a harassment-free experience for everyone. By participating in this project, you agree to abide by its [Code of Conduct](https://github.com/cap-js-community/.github/blob/main/CODE_OF_CONDUCT.md) at all times.

## Licensing

Copyright 2023 SAP SE or an SAP affiliate company and cds-cucumber contributors. Please see our [LICENSE](LICENSE) for copyright and license information. Detailed information including third-party components and their licensing/copyright information is available [via the REUSE tool](https://api.reuse.software/info/github.com/cap-js-community/cds-cucumber).

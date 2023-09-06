# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Version 0.2.0 - 2023-09-06

### Added

* OData steps

### Changed

* Readme: switch to bookshop sample "cds add sample"

### Fixed

* Readme: install from npm repository
* Plugins:
  - reject failing commands
  - hide test plugins
* Concurrency:
  - allow cucumber parallel jobs: `npx cucumber-js test --parallel 2`
  - create new working directory (username and process ID dependent) using it as follows:
    - Chrome: user data directory
    - CAP services: home directory
* Steps:
  - detect technical issues when selecting tiles
  - detect missing ValueHelp popup
  - add new step: remove ValueHelp selection
  - locating active dialog
* cucumber:
  - remove deprecated configuration: publishQuiet

## Version 0.1.0 - 2023-07-10

### Added

- Initial version

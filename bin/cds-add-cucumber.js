#!/usr/bin/env node

const fs = require('node:fs');

createCucumberConfiguration();
createTestFeaturesDir();
createVSCodePluginConfig();
createGitHubActionsWorkflow();
if(!createBookshopFirstFeatureFile()) {
  createFirstFeatureFile();
  createAnnotationsForCdsDkSamples();
}

function createCucumberConfiguration() {
  const content = `default:
  requireModule:
    - "${getModuleName()}"
`
  const file = 'cucumber.yml';

  createFileIfMissing(file, content);
}

function getModuleName() {
  return require('../package.json').name;
}

function mkdir(dir) {
  if(!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
    console.log(`Created directory ${dir}`)
  } else {
    console.log(`Directory ${dir} already exists`)
  }
}

function createTestFeaturesDir() {
  mkdir('./test');
  mkdir('./test/features');
  mkdir('./test/features/step_definitions');
}

function createVSCodePluginConfig() {
  const settingsJson = `{
  // Cucumber for Visual Studio Code (CucumberOpen) https://open-vsx.org/extension/CucumberOpen/cucumber-official 
  "cucumber.features": [
    "test/features/**/*.feature"
  ],
  "cucumber.glue": [
    "test/features/step_definitions/**/*.js",
    "node_modules/${getModuleName()}/lib/steps/**/*.js"
  ],
  // Cucumber (Gherkin) Full Support https://marketplace.visualstudio.com/items?itemName=alexkrechik.cucumberautocomplete
  "cucumberautocomplete.steps": [
    "test/features/step_definitions/*.js",
    "node_modules/${getModuleName()}/lib/steps/**/*.js"
  ],
  "cucumberautocomplete.strictGherkinCompletion": true
}
`

  const extensionsJson = `{
  "recommendations": [
    "cucumberopen.cucumber-official",
  ]
}
`
  mkdir('./.vscode');

  createFileIfMissing('./.vscode/settings.json', settingsJson);
  createFileIfMissing('./.vscode/extensions.json', extensionsJson);

}

function createGitHubActionsWorkflow() {
  const content = `name: test-with-cached-ui5
on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]
jobs:
  test-with-cached-ui5:
    name: Test with cached UI5
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [ 18 ]
        sap-ui5-version: [ 1.120.11 ]
    steps:
      - uses: actions/checkout@v3

      - name: Setup Node.js \${{ matrix.node-version }}
        uses: actions/setup-node@v3
        with:
          node-version: \${{ matrix.node-version }}

      - name: prepare
        run: npm ci

      - name: Add UI5 local tgz plugin
        run: npx cds-add-cucumber-plugin -p local-ui5-tgz -f app/index.html

      - uses: actions/cache/restore@v3
        id: cache-ui5
        with:
          path: tmp/sapui5/sapui5-\${{ matrix.sap-ui5-version }}.tgz
          key: sapui5-\${{ matrix.sap-ui5-version }}-tgz

      - name: Build UI5
        if: steps.cache-ui5.outputs.cache-hit != 'true'
        env:
          SAP_UI5_VERSION: \${{ matrix.sap-ui5-version }}
        run: npx cds-cucumber-build-ui5-tgz

      - uses: actions/cache/save@v3
        if: steps.cache-ui5.outputs.cache-hit != 'true'
        with:
          path: tmp/sapui5/sapui5-\${{ matrix.sap-ui5-version }}.tgz
          key: sapui5-\${{ matrix.sap-ui5-version }}-tgz

      - uses: actions/cache/restore@v3
        id: cache-selenium
        with:
          path: tmp/selenium.tar
          key: selenium

      - name: download selenium
        if: steps.cache-selenium.outputs.cache-hit != 'true'
        run: docker pull selenium/standalone-chrome && docker image save selenium/standalone-chrome --output tmp/selenium.tar

      - uses: actions/cache/save@v3
        if: steps.cache-selenium.outputs.cache-hit != 'true'
        with:
          path: tmp/selenium.tar
          key: selenium

      - name: load selenium
        run: docker image load --input tmp/selenium.tar

      - name: run selenium
        run: docker run -d -p 4444:4444 --network host selenium/standalone-chrome

      - name: test
        env:
          BRANCH_NAME: \${{ github.head_ref || github.ref_name }}
          SAP_UI5_VERSION: \${{ matrix.sap-ui5-version }}
          SAPUI5_ARCHIVE_FILE: ./tmp/sapui5/sapui5-\${{ matrix.sap-ui5-version }}.tgz
          SELENIUM_REMOTE_URL: http://127.0.0.1:4444/wd/hub
        run: npx cucumber-js test
`
  const file = '.github/workflows/test-cached-ui5-tgz.yml';

  mkdir('.github');
  mkdir('.github/workflows');

  createFileIfMissing(file, content);
}

function createFirstFeatureFile() {
  const content = `Feature: Fiori preview page

  Scenario: Open first Fiori preview page
    Given we have started the application
      And we have opened the url "/"
    When we click on first Fiori preview page
      And we search for "jane"
    Then we expect to have 1 table records
`
  const file = './test/features/first.feature';

  // detect "cds add samples"
  if(!fs.existsSync('./srv/cat-service.cds')) return;
  if(!fs.existsSync('./db/data-model.cds')) return;
  if(!fs.existsSync('./db/data/my.bookshop-Books.csv')) return;

  createFileIfMissing(file, content);

}

// Fiori Preview page part of "cds add samples" does not have FE annotations - basic search does not work
function createAnnotationsForCdsDkSamples() {
  const content = `annotate CatalogService.Books with @(
    Common.SemanticKey : [ID],
    UI                 : {
        SelectionFields : [title],
        LineItem        : [
            {Value : title}
        ],
    }
);

annotate CatalogService.Books with @(UI : {HeaderInfo : {
    TypeName       : 'Book',
    TypeNamePlural : 'Books',
    Title          : {Value : title},
    Description    : {Value : title}
}, });

annotate CatalogService.Books with {
    id   @title : 'Id';
    title @title : 'Title';
};
`
  const file = './srv/annotations.cds';

  // detect "cds add samples"
  if(!fs.existsSync('./srv/cat-service.cds')) return;
  if(!fs.existsSync('./db/data-model.cds')) return;
  if(!fs.existsSync('./db/data/my.bookshop-Books.csv')) return;

  createFileIfMissing(file, content);

}

function createBookshopFirstFeatureFile() {
  const content = `Feature: Bookshop first feature file

  Scenario: Open "Manage Books" as "alice" and search for "jane"
    Given we have started the application
      And we have opened the url "/" with user "alice"
    When we select tile "Manage Books"
      And we search for "jane"
    Then we expect to have 2 table records
`
  const file = './test/features/bookshop.feature';

  // detect "cds add sample"
  if(!fs.existsSync('./app/index.html')) return false;
  if(!fs.existsSync('./app/common.cds')) return false;
  if(!fs.existsSync('./app/services.cds')) return false;
  if(!fs.existsSync('./app/admin-books/fiori-service.cds')) return false;
  if(!fs.existsSync('./srv/cat-service.cds')) return false;
  if(!fs.existsSync('./srv/cat-service.js')) return false;
  if(!fs.existsSync('./srv/admin-service.cds')) return false;
  if(!fs.existsSync('./srv/admin-service.js')) return false;
  if(!fs.existsSync('./db/schema.cds')) return false;
  if(!fs.existsSync('./db/data/sap.capire.bookshop-Authors.csv')) return false;
  if(!fs.existsSync('./db/data/sap.capire.bookshop-Books.csv')) return false;
  if(!fs.existsSync('./db/data/sap.capire.bookshop-Books_texts.csv')) return false;
  if(!fs.existsSync('./db/data/sap.capire.bookshop-Genres.csv')) return false;

  createFileIfMissing(file, content);
  return true;
}

function createFileIfMissing(file, content) {
  if(!fs.existsSync(file)) {
    fs.writeFileSync(file, content);
    console.log(`Created file ${file}`);
  } else {
    console.log(`File ${file} already exists`);
  }
}

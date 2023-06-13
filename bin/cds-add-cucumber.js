#!/usr/bin/env node

const fs = require('fs');

createCucumberConfiguration();
createTestFeaturesDir();
createVSCodePluginConfig();
createFirstFeatureFile();
createAnnotationsForCdsDkSamples();

function createCucumberConfiguration() {
  const content = `default:
    publishQuiet: true
    requireModule:
      - "${getModuleName()}"
  `
  const file = 'cucumber.yml';

  createFileIfMissing(file, content);
}

function getModuleName() {
  return JSON.parse(String(fs.readFileSync(require.resolve('../package.json')))).name;
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
  const content = `{
  "cucumberautocomplete.steps": [
    "test/features/step_definitions/*.js",
    "node_modules/${getModuleName()}/lib/steps/*.js"
  ],
  "cucumberautocomplete.strictGherkinCompletion": true
}
`
  mkdir('./.vscode');

  const file = './.vscode/settings.json';

  createFileIfMissing(file, content);

}

function createFirstFeatureFile() {
  const content = `Feature: Fiori preview page

  Scenario: Open first Fiori preview page
    Given we have started the CAP application
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

function createFileIfMissing(file, content) {
  if(!fs.existsSync(file)) {
    fs.writeFileSync(file, content);
    console.log(`Created file ${file}`);
  } else {
    console.log(`File ${file} already exists`);
  }
}

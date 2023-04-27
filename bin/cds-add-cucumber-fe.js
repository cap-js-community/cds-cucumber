#!/usr/bin/env node

const fs = require('fs');

createCucumberConfiguration();
createTestFeaturesDir();
createVSCodePluginConfig();
createFirstFeatureFile();

function createCucumberConfiguration() {
  const content = `default:
    publishQuiet: true
    requireModule:
      - ${getModuleName()}
  `
  const file = 'cucumber.yml';

  if(!fs.existsSync(file)) {
    fs.writeFileSync(file, content);
    console.log(`Created file ${file}`);
  } else {
    console.log(`File ${file} already exists`);
  }
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

  if(!fs.existsSync(file)) {
    fs.writeFileSync(file, content);
    console.log(`Created file ${file}`);
  } else {
    console.log(`File ${file} already exists`);
  }

}

function createFirstFeatureFile() {
  const content = `Feature: Fiori preview page

  Scenario: Open first Fiori preview page
    Given we have started the application
      And we have opened the url "/"
    When we click on first Fiori preview page
      And we perform basic search for "jane"
    Then we expect to have 1 table records
`
  const file = './test/features/first.feature';

  if(!fs.existsSync(file)) {
    fs.writeFileSync(file, content);
    console.log(`Created file ${file}`);
  } else {
    console.log(`File ${file} already exists`);
  }

}
Step definitions
================

# Initialization
## Start application
```gherkin
Given we have started the application
```
Starts the application process with default settings:
- stack: node
- command: npx cds run

## Open web page

* open specified web page
```gherkin
Given we have opened the url "/"
```
* plain pages (without SAP UI5) - limited steps support
* protected pages require credentials

# Actions

## Basic search

```gherkin
Given we perform basic search for "string"
```
* target: basic search field in filter bar

## Apply search filter

```gherkin
When we apply the search filter
```

## Value help

```gherkin
When we open value help for field {string}
```
* supports filter fields, object fields
# Expectations

## Table contains record(s)
* specific record
```gherkin
Then we expect table {string} to contain record
"""
{"name":value}
"""
```

* several records

```gherkin
Then we expect table {string} to contain records
"""
[{"name":value}]
"""
```


## Table does not contain record(s)

* specific record

```gherkin
Then we expect table {string} not to contain record
"""
{"name":value}
"""
```

* several records

```gherkin
Then we expect table {string} not to contain records
"""
[{"name":value}]
"""
```

## Total count of records in table

* tabel with specific label
```gherkin
Then we expect table {string} to have {int} records in total
```

* target ListReport table without naming it
```gherkin
Then we expect to have {int} table records
```

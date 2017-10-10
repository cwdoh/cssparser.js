## Usage

### from Command-line


First of all, you should install cssparser.

```bash
$ npm install cssparser
```
or
```bash
$ npm install cssparser -g
```

Then execute and you can generate JSON file from command-line.

```bash
$ cssparser cssFile
```	
or 
```bash	
$ cssparser cssFile -o output_file
```

### from CommonJS Module

You can generate javascript object from your javascript module.

```javascript
// getting parser module
var cssparser = require("cssparser");

// create new instance of Parser
var parser = new cssparser.Parser();

// parse
var ast = parser.parse(raw)

// getting json
var json = ast.toJSON(type)
```

## Generating parser from source

### Getting jison & source

```bash
$ git clone https://github.com/cwdoh/cssparser.js.git
$ npm install
```

### Generating parser from source

```bash
$ npm run build
```

## JSON Structure

There are 3 types of JSON format.

* simple - most simple.
	* simply consist of just key & value.
* deep - more detailed then simple mode.
	* this includes more informations of selector, terms, expression, queries, …
* atomic - most detailed. 'atomic' JSON has all pieces of each key & values in CSS.
	* e.g. length has numeric value & its unit like "100px" -> { "value": 100, "unit": "px" }

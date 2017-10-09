![Travis Build Status - Master](https://img.shields.io/travis/cwdoh/cssparser.js/master.svg)
![Travis Build Status - Develop](https://img.shields.io/travis/cwdoh/cssparser.js/develop.svg)
![npm downloads in the last month](https://img.shields.io/npm/dm/cssparser.svg)
![npm total downloads](https://img.shields.io/npm/dt/cssparser.svg)

cssparser.js
======

cssparser.js is a parser that generates json matched with source css structure.

## Description

* License: MIT license - [http://www.opensource.org/licenses/mit-license.php](http://www.opensource.org/licenses/mit-license.php)
* Author : Chang W. Doh

## Demo

* [http://cwdoh.github.io/cssparser.js/demo/CSS_stringify.html](//cwdoh.github.io/cssparser.js/demo/CSS_stringify.html)

## Dependency

Just want to use cssparser.js? Nothing needed.

If want generating parser, install 'jison' before it.

* Jison - [http://jison.org](http://jison.org )


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

## Example

Example is tested with rulesets of [http://css3please.com](http://css3please.com)

```bash
cssparser example/test.css --console -i 4
```

### Input

```css
@charset 'utf-8';
@import url("fineprint.css") print;
@media screen {
    * {
       position: absolute;
     }
}
 
.footer {
    position: fixed;
    bottom: 0 !important;
    width: 1rem;
}
```

### JSON Output

#### Type 'simple'

```javascript
[
    {
        "type": "@charset",
        "value": "'utf-8'"
    },
    {
        "type": "@import",
        "value": "url(\"fineprint.css\")",
        "mediaQuery": [
            "print"
        ]
    },
    {
        "type": "@media",
        "value": [
            "screen"
        ],
        "nestedRules": [
            {
                "type": "rule",
                "selectors": [
                    "*"
                ],
                "declarations": {
                    "position": "absolute"
                }
            }
        ]
    },
    {
        "type": "rule",
        "selectors": [
            ".footer"
        ],
        "declarations": {
            "position": "fixed",
            "bottom": "0 !important",
            "width": "1rem"
        }
    }
]

```

####Type 'deep'

```javascript
{
    "type": "STYLESHEET",
    "value": [
        {
            "type": "AT_RULE",
            "rule": "charset",
            "value": "'utf-8'"
        },
        {
            "type": "AT_RULE",
            "rule": "import",
            "value": "url(\"fineprint.css\")",
            "nextExpression": [
                "print"
            ]
        },
        {
            "type": "AT_RULE",
            "rule": "media",
            "value": [
                "screen"
            ],
            "nestedRules": [
                {
                    "type": "QUALIFIED_RULE",
                    "value": {
                        "type": "DECLARATION_LIST",
                        "value": [
                            {
                                "type": "DECLARATION",
                                "property": "position",
                                "value": "absolute"
                            }
                        ]
                    },
                    "selectors": [
                        "*"
                    ]
                }
            ]
        },
        {
            "type": "QUALIFIED_RULE",
            "value": {
                "type": "DECLARATION_LIST",
                "value": [
                    {
                        "type": "DECLARATION",
                        "property": "position",
                        "value": "fixed"
                    },
                    {
                        "type": "DECLARATION",
                        "property": "bottom",
                        "value": 0,
                        "important": true
                    },
                    {
                        "type": "DECLARATION",
                        "property": "width",
                        "value": "1rem"
                    }
                ]
            },
            "selectors": [
                ".footer"
            ]
        }
    ]
}

```

#### Type 'atomic'

```javascript
{
    "type": "STYLESHEET",
    "value": [
        {
            "type": "AT_RULE",
            "rule": {
                "type": "ID",
                "value": "charset",
                "prefix": "@"
            },
            "value": {
                "type": "STRING",
                "value": "'utf-8'"
            }
        },
        {
            "type": "AT_RULE",
            "rule": {
                "type": "ID",
                "value": "import",
                "prefix": "@"
            },
            "value": {
                "type": "URL",
                "name": {
                    "type": "ID",
                    "value": "url"
                },
                "value": "\"fineprint.css\""
            },
            "nextExpression": {
                "type": "MEDIA_QUERY_LIST",
                "value": [
                    {
                        "type": "MEDIA_QUERY",
                        "mediaType": {
                            "type": "ID",
                            "value": "print"
                        }
                    }
                ]
            }
        },
        {
            "type": "AT_RULE",
            "rule": {
                "type": "ID",
                "value": "media",
                "prefix": "@"
            },
            "value": {
                "type": "MEDIA_QUERY_LIST",
                "value": [
                    {
                        "type": "MEDIA_QUERY",
                        "mediaType": {
                            "type": "ID",
                            "value": "screen"
                        }
                    }
                ]
            },
            "nestedRules": [
                {
                    "type": "QUALIFIED_RULE",
                    "value": {
                        "type": "DECLARATION_LIST",
                        "value": [
                            {
                                "type": "DECLARATION",
                                "property": {
                                    "type": "ID",
                                    "value": "position"
                                },
                                "value": {
                                    "type": "ID",
                                    "value": "absolute"
                                }
                            }
                        ]
                    },
                    "selectors": {
                        "type": "SELECTOR_LIST",
                        "value": [
                            {
                                "type": "UNIVERSAL_SELECTOR",
                                "value": "*"
                            }
                        ]
                    }
                }
            ]
        },
        {
            "type": "QUALIFIED_RULE",
            "value": {
                "type": "DECLARATION_LIST",
                "value": [
                    {
                        "type": "DECLARATION",
                        "property": {
                            "type": "ID",
                            "value": "position"
                        },
                        "value": {
                            "type": "ID",
                            "value": "fixed"
                        }
                    },
                    {
                        "type": "DECLARATION",
                        "property": {
                            "type": "ID",
                            "value": "bottom"
                        },
                        "value": {
                            "type": "NUMBER",
                            "value": 0
                        },
                        "important": true
                    },
                    {
                        "type": "DECLARATION",
                        "property": {
                            "type": "ID",
                            "value": "width"
                        },
                        "value": {
                            "type": "DIMENSION",
                            "value": 1,
                            "unit": "rem"
                        }
                    }
                ]
            },
            "selectors": {
                "type": "SELECTOR_LIST",
                "value": [
                    {
                        "type": "CLASS_SELECTOR",
                        "value": ".footer"
                    }
                ]
            }
        }
    ]
}
```

## Change log

* 0.9.4 - October 10th, 2017
    * Fixed missing space after attribute selector by #23, thanks @kauffecup
* 0.9.3 - July 20th, 2017
	* Fixed producing undefined for expression when using simple mode.
    * Supported IE hacks including `_PROPERTY` pattern.
* 0.9.2 - March 17th, 2017
	* Now supports beautify delimiter option for simple & deep type.
    * Showing version will be run lower-case 'v' instead 'V'.
    * Fixed missing keyframe name and added type & level descriptions for simple type.
    * Fixed EOF error case.
    * Added '-b' option for beautify delimiters.
* 0.9.1 - March 8th, 2017
	* Added 'rule' type on the css style node when simple mode. 
* 0.9.0 - March 5th, 2017
	* Fully rewrited parser.
	* Supports three modes such as simple, deep, atomic.
		* Also, simple mode produced different results instead of the format of previous version.
* 0.2.2 - July 27th, 2013
	* Add ratio type expression with '/'. thanks to Mohsen Heydari.
* 0.2.1 - May 21st, 2013
	* Update grunt, dependencies, cli options & output message.
	* Add 'keyframe' type at child node of keyframes.
* 0.2.0 - May 20th, 2013
	* Initial release of cssparser.js.

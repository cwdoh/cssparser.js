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
  const
    AT_RULE = "AT_RULE",

    MEDIA_QUERIES = "MEDIA_QUERIES",
    MEDIA_QUERY = "MEDIA_QUERY",
    MEDIA_QUERY_EXPR = "MEDIA_QUERY_EXPR",

    FONT_FACE = "FONT_FACE",

    /*
     * Ref: [1] https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Selectors 
     */
    SELECTOR = "SELECTOR",
    TYPE_SELECTOR = "TYPE_SELECTOR",
    CLASS_SELECTOR = "CLASS_SELECTOR",
    ID_SELECTOR = "ID_SELECTOR",
    UNIVERSAL_SELECTOR = "UNIVERSAL_SELECTOR",
    ATTR_SELECTOR = "ATTR_SELECTOR",
    ATTR_OPERATOR = "ATTR_OPERATOR",
    PSEUDO_CLASS = "PSEUDO_CLASS",
    PSEUDO_ELEMENT = "PSEUDO_ELEMENT",
    SELECTOR_COMBINATOR = "SELECTOR_COMBINATOR",

    CSS_RULE = "CSS_RULE",
    DECLARATIONS = "DECLARATIONS",
    DECLARATION = "DECLARATION",

    ATTRIBUTE = "ATTRIBUTE",

    CALC_OPERATION = "CALC_OPERATION",
    EXPRESSION = "EXPRESSION",

    MEDIA_TYPE = "MEDIA_TYPE",

    KEYFRAMES_BLOCK = "KEYFRAMES_BLOCK",

    FUNCTIONS = "FUNCTIONS",
    FUNCTION = "FUNCTION",

    SEQUENCE = "SEQUENCE",
    DIMENSION = "DIMENSION",

    PERCENTAGE = "PERCENTAGE",
    NUMBER = "NUMBER",

    EndOfList = ''

  const keyframesVal = function(selector, val) {
    return {
      type: KEYFRAMES_BLOCK,
      selector: selector,
      value: val
    }
  }

  const urlVal = function(val) {
    return {
      type: 'URL',
      value: val
    }
  }

  const numberVal = function(val) {
    return {
      type: 'NUMBER',
      value: parseFloat(val)
    }
  }

  const stringVal = function(val) {
    return {
      type: 'STRING',
      value: val
    }
  }

  const hashVal = function(val) {
    return {
      type: 'HASH',
      value: val
    }
  }

  const operationVal = function(operator, lhs, rhs) {
    return {
      type: CALC_OPERATION,
      lhs: lhs,
      operator: operator,
      rhs: rhs
    }
  }
  const functionVal = function(name, parameters) {
    var value = {
      type: FUNCTION,
      name: name
    }

    if (parameters) {
      value.parameters = parameters
    }

    return value
  }

  const defVariable = function(type, value) {
    // console.log('defVariable\t=', type, value)
    return {
      type: type,
      value: value
    }
  }

  const selectorComponent = function(selectorType, value, combinator) {
    var component = defVariable(selectorType, (typeof(value) == 'string')? value.trimRight(): value)

    if (combinator) {
      return merge(component, combinator)
    }

    return component
  }
  
  const selectorCombinator = function(combinatorType, value) {
    return {
      type: SELECTOR_COMBINATOR,
      value: defVariable(combinatorType, value)
    }
  }

  const removeTailingSelectorCombinator = function(list) {
    if (list.length > 0) {
      var lastItem = list[list.length - 1]

      if (lastItem.type == SELECTOR_COMBINATOR) {
        list.pop()
        return list
      }
    }

    return list
  }

  const atRule = function(rule, value, optKey, optVal) {
    // console.log('atRule\t\t = ', rule, value, optKey, optVal)
    var ruleValue = {
      type: AT_RULE,
      rule: rule
    }

    if (value) {
      ruleValue.value = value
    }
    if (optKey) {
      ruleValue[optKey] = optVal
    }

    return ruleValue
  }

  const mediaQuery = function(operator, mediaType, expressions) {
    // console.log('mediaQuery\t = ', operator, mediaType, JSON.stringify(expression))
    var mediaQueryValue = {
      type: MEDIA_TYPE
    }

    if (operator) {
      mediaQueryValue.operator = operator
    }
    if (mediaType) {
      mediaQueryValue.value = mediaType
    }
    if (expressions) {
      mediaQueryValue.expressions = expressions
    }

    return defVariable(MEDIA_QUERY, mediaQueryValue)
  }

  const mediaQueryExpr = function(feature, value) {
    var mediaQueryValue = {
      type: MEDIA_QUERY_EXPR
    }
    if (feature) {
      mediaQueryValue.feature = feature
    }
    if (value) {
      mediaQueryValue.value = value
    }

    return mediaQueryValue
  }

  const addProp = function(o, prop, value) {
    if (prop in o) {
      throw new Error('Object already has property: ' + prop)
    }
    
    if (value) {
      o[prop] = value
    }

    return o
  }

  const addComment = function(o, comment) {
    return addProp(o, 'comment', comment)
  }

  const declarations = function(value) {
    var cssDeclarations = {
      type: DECLARATIONS,
      value: value
    }

    return cssDeclarations
  }

  const cssDeclarationVal = function(property, value, important) {
    var cssDeclarationValue = {
      type: DECLARATION,
      property: property,
      value: value
    }

    if (important) {
      cssDeclarationValue.important = true
    }

    return cssDeclarationValue
  }

  const merge = function(lVal, rVal) {
    // console.log('lVal = (' + typeof(lVal) + ')' + JSON.stringify(lVal), 'rVal = (' + typeof(rVal) + ')' + JSON.stringify(rVal))

    if (!(lVal instanceof(Array))) {
      lVal = [lVal]
    }
    if (!(rVal instanceof(Array))) {
      rVal = [rVal]
    }

    return lVal.concat(rVal)
  }

  const join = function(list, key, separator) {
    var result = []
    separator = separator || ''

    if (key) {
      for (var k in list) {
        var it = list[k]

        if (key in it) {
          result.push(it[key])
        } else {
          throw new Error('No such key in the list')
        }
      }
    } else {
      result = list
    }

    return result.join(separator)
  }

  const sequencialVal = function(list) {
    if (list.length > 1)
      return {
        type: SEQUENCE,
        value: list
      }

    return list
  }

  const vendorPrefixIdVal = function(val) {
    const identPattern = /([-](webkit|moz|o|ms)[-])([0-9a-zA-Z-]*)/
    var result = val.match(identPattern)

    if (result) {
      return {
        type: 'ID',
        vendorPrefix: result[1],
        value: result[3]
      }
    }

    return {
      type: 'ID',
      value: val
    }
  }

  const unitVal = function(type, val) {
    const pattern = /(([\+\-]?[0-9]+(\.[0-9]+)?)|([\+\-]?\.[0-9]+))([a-zA-Z]+)/
    var result = val.match(pattern)

    if (result) {
      return {
        type: type,
        value: parseFloat(result[1]),
        unit: result[5]
      }
    }

    return {
      type: type,
      value: val
    }
  }

  const dimensionUnitVal = function(val) {
    return unitVal(DIMENSION, val)
  }

  const percentageVal = function(val) {
    const pattern = /(([\+\-]?[0-9]+(\.[0-9]+)?)|([\+\-]?\.[0-9]+))([%])/
    var result = val.match(pattern)

    if (result) {
      return {
        type: PERCENTAGE,
        value: parseFloat(result[1]),
        unit: result[5]
      }
    }

    return {
      type: PERCENTAGE,
      value: val
    }
  }
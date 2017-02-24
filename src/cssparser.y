%{
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

    CALC_EXPRESSION = "CALC_EXPRESSION",

    MEDIA_TYPE = "MEDIA_TYPE",

    KEYFRAMES_BLOCK = "KEYFRAMES_BLOCK",

    FUNCTIONS = "FUNCTIONS",
    FUNCTION = "FUNCTION",

    DIMENSIONS = "DIMENSIONS",
    DIMENSION = "DIMENSION",

    PERCENTAGE = "PERCENTAGE",
    NUMBER = "NUMBER",

    EndOfList = ''

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

  const multiDimesionsVal = function(list) {
    if (list.length > 1)
      return {
        type: DIMENSIONS,
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
        value: result[3],
        fullQuailfied: val
      }
    }

    return {
      type: 'ID',
      value: val,
      fullQuailfied: val
    }
  }

  const unitVal = function(type, val) {
    const pattern = /(([\+\-]?[0-9]+(\.[0-9]+)?)|([\+\-]?\.[0-9]+))([a-zA-Z]+)/
    var result = val.match(pattern)

    if (result) {
      return {
        type: type,
        value: parseFloat(result[1]),
        unit: result[5],
        fullQuailfied: val
      }
    }

    return {
      type: type,
      value: val,
      fullQuailfied: val
    }
  }

  const demensionUnitVal = function(val) {
    return unitVal(DIMENSION, val)
  }

  const percentageVal = function(val) {
    const pattern = /(([\+\-]?[0-9]+(\.[0-9]+)?)|([\+\-]?\.[0-9]+))([%])/
    var result = val.match(pattern)

    if (result) {
      return {
        type: PERCENTAGE,
        value: parseFloat(result[1]),
        unit: result[5],
        fullQuailfied: val
      }
    }

    return {
      type: PERCENTAGE,
      value: val,
      fullQuailfied: val
    }
  }
%}

%start stylesheet

%%
stylesheet
  : stylesheet_list EOF
    %{
      $$ = {
        type: 'STYLESHEET',
        value: $1
      }

      return $$
    }%
  ;

stylesheet_list
  : stylesheet_component
    %{
      $$ = []
      if ($1)
        $$.push($1)
    }%
  | stylesheet_component stylesheet_list
    %{
      if ($1 == null) {
        $$ = $2
        return
      }

      $$ = [$1].concat($2)
    }%
  ;

stylesheet_component
  : CDO             -> $1
  | CDC             -> $1
  | qualified_rule  -> $1
  | at_rule         -> $1
  ;

rule_list
  : rule_list_component                   -> [$1]
  | rule_list_component rule_list         -> [$1].concat($2)
  ;

rule_list_component
  : qualified_rule    -> $1
  | at_rule           -> $1
  ;

/********************
** AT RULES
**
** referenced rules is on MDN[1].
**
** [1] https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule
********************/

at_rule
  : at_rule_simple SEMICOLON
  | at_rule_nested
  | at_rule_font_face
  ;

at_rule_simple
  : at_rule_charset
  | at_rule_import
  | at_rule_namespace
  ;

at_rule_charset
  : AT_CHARSET StringVal     -> atRule($AT_CHARSET, $StringVal)
  ;
at_rule_import
  : AT_IMPORT UrlOrStringVal                              -> atRule($1, $2)
  | AT_IMPORT UrlOrStringVal media_query_list             -> atRule($1, $2, 'mediaQueries', $3)
  ;
at_rule_namespace
  : AT_NAMESPACE UrlOrStringVal               -> atRule($1, $2)
  | AT_NAMESPACE IDENT UrlOrStringVal         -> atRule($1, $3, 'prefix', $2)
  ;

at_rule_nested
  : at_rule_nested_frontpart rule_block -> addProp($1, 'nestedRules', $2)
  | at_rule_keyframes
  | at_rule_page
  ;

at_rule_nested_frontpart
  : at_rule_media
  | at_rule_document
  | at_rule_supports
  ;

at_rule_media
  : AT_MEDIA media_query_list   -> atRule($1, null, 'mediaQueries', $2)
  ;

rule_block
  : LEFT_CURLY_BRACKET rule_list RIGHT_CURLY_BRACKET          -> $2
  | LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET                    -> null
  ;

at_rule_keyframes
  : AT_KEYFRAMES keyframes_name keyframes_block   -> atRule($1, $3, 'name', $2)
  ;
keyframes_block
  : LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET                        -> null
  | LEFT_CURLY_BRACKET keyframes_block_list RIGHT_CURLY_BRACKET   -> $2
  ;
keyframes_block_list
  : keyframes_block
  | keyframes_block_list keyframes_block  -> merge($1, $2)
  ;
keyframes_block
  : keyframes_selector Declarations       -> { type: KEYFRAMES_BLOCK, selector: $1, declarations: $2 }
  ;
keyframes_name
  : IdentVal
  | StringVal
  ;
keyframes_selector
  : IdentVal
  | PercentageVal
  ;

/* TODO: I don't understand @page rules deeply. */
at_rule_page
  : at_rule_page_frontpart Declarations   -> addProp($1, 'declarations', $2)
  ;

at_rule_page_frontpart
  : AT_PAGE                   -> atRule($1, null)
  | AT_PAGE SelectorPseudoClassList   -> atRule($1, null, 'pseudoClasses', $2)
  ;

at_rule_document
  : AT_DOCUMENT AtDocumentFuncValList -> atRule($1, null, 'value', { type: FUNCTIONS, value: $2 })
  ;
AtDocumentFuncValList
  : AtDocumentFuncVal
  | AtDocumentFuncValList COMMA AtDocumentFuncVal   -> merge($1, $3)
  ;
AtDocumentFuncVal
  : URL_FUNC            -> { type: FUNCTION, name: "url", value: $1 }
  | URL_PREFIX_FUNC     -> { type: FUNCTION, name: "url-prefix", value: $1 }
  | DOMAIN_FUNC         -> { type: FUNCTION, name: "domain", value: $1 }
  | REGEXP_FUNC         -> { type: FUNCTION, name: "regexp", value: $1 }
  ;

at_rule_font_face
  : AT_FONT_FACE Declarations   -> { type: FONT_FACE, declarations: $2 }
  ;

/* TODO: I don't understand @supports rules deeply. */
at_rule_supports
  : AT_SUPPORTS supports_expression_list   -> atRule($1, null, 'expressions', $2)
  ;

supports_expression_list
  : supports_expression
  | supports_expression_list supports_and_or_expression  -> merge($1, $2)
  ;
supports_and_or_expression
  : OperatorAndOr supports_expression                                -> { operator: $1, expression: $2 }
  ;
supports_expression
  : supports_expression_body                  -> { value: $1 }
  | OPERATOR_NOT supports_expression_body     -> { value: $2, not: true }
  ;
OperatorAndOr
  : OPERATOR_AND
  | OPERATOR_OR
  ;

supports_expression_body
  : LEFT_PARENTHESIS ComponentName COLON DeclarationPropValList RIGHT_PARENTHESIS   -> { property: $2, value: $4 }
  ;

/********************
** MEDIA QUERY
**
** referenced rules is on MDN[1].
**
** [1] https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries#Pseudo-BNF
********************/

media_query_list
  : media_query_group -> { type: MEDIA_QUERIES, value: $1 }
  ;

media_query_group
  : media_query                             -> [$1]
  | media_query COMMA media_query_group     -> $3.concat([$1])
  ;

media_query
  : IDENT                                                    -> mediaQuery(null, $1)
  | IDENT media_query_and_expression_list                    -> mediaQuery(null, $1, $2)
  | OPERATOR_ONLY_NOT IDENT                                  -> mediaQuery($1, $2)
  | OPERATOR_ONLY_NOT IDENT media_query_and_expression_list  -> mediaQuery($1, $2, $3)
  | media_query_expression_list                              -> mediaQuery(null, null, $1)
  ;
OPERATOR_ONLY_NOT
  : OPERATOR_ONLY
  | OPERATOR_NOT
  ;
media_query_expression_list
  : media_query_expression media_query_and_expression_list      -> merge($1, $2)
  | media_query_expression                                      -> [$1]
  ;
media_query_and_expression_list
  : media_query_and_expression_list media_query_and_expression  -> merge($1, $2)
  | media_query_and_expression                                  -> [$1]
  ;
media_query_and_expression
  : OPERATOR_AND media_query_expression              -> addProp($2, 'operator', $1)
  ;
media_query_expression
  /* Basically we have to use MEDIA_FEATURE[1]. How do I treat non-error cases such as unknown features?
   * [1] https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries#Pseudo-BNF
   */
  : LEFT_PARENTHESIS MediaFeature RIGHT_PARENTHESIS                      -> mediaQueryExpr($2)
  | LEFT_PARENTHESIS MediaFeature COLON GenericVal RIGHT_PARENTHESIS     -> mediaQueryExpr($2, $4)
  ;
MediaFeature
  : IdentVal
  ;

/********************
** QUALIFIED RULES
**
** referenced rules is on MDN[1].
**
** [1] https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule
********************/

qualified_rule
  : css_rule    -> $1
  ;

css_rule
  : SelectorList Declarations
    %{
        // console.log(' => CSS_RULE')
        $$ = {
          type: CSS_RULE,
          selectors: $1,
          declarations: $2
        }
    }%
  ;

Declarations
  : LEFT_CURLY_BRACKET DeclarationList DeclarationComponent RIGHT_CURLY_BRACKET     -> declarations(merge($2, $3))
  | LEFT_CURLY_BRACKET DeclarationList RIGHT_CURLY_BRACKET                          -> declarations($2)
  | LEFT_CURLY_BRACKET DeclarationComponent RIGHT_CURLY_BRACKET                     -> declarations($2)
  | LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET                                          -> []
  ;
DeclarationList
  : Declaration                     -> [$1]
  | DeclarationList Declaration    -> merge($1, $2)
  ;
Declaration
  : DeclarationComponent SEMICOLON      -> $1
  ;
DeclarationComponent
  : DeclarationPropName COLON DeclarationPropValLists IMPORTANT   -> cssDeclarationVal($1, $3, $4)
  | DeclarationPropName COLON DeclarationPropValLists             -> cssDeclarationVal($1, $3)
  ;

/********************
 * CSS Selector
 *
 * ref. [1] https://developer.mozilla.org/en-US/docs/Learn/CSS/Introduction_to_CSS/Combinators_and_multiple_selectors
 *      [2] https://www.w3.org/TR/css3-selectors/#combinators
 */

SelectorList
  : SelectorGroup                        -> defVariable(SELECTOR, removeTailingSelectorCombinator($1))
  | SelectorList COMMA SelectorGroup     -> merge($1, defVariable(SELECTOR, removeTailingSelectorCombinator($3)))
  ;
SelectorGroup
  : Selector
  | SelectorGroup Selector                        -> merge($1, $2)
  | SelectorGroup SelectorCombinator Selector     -> merge($1, [$2, $3])
  ;
SelectorCombinator
  : GREATER_THAN_SIGN   -> selectorCombinator("CHILD", $1)
  | PLUS_SIGN           -> selectorCombinator("ADJACENT_SIBLING", $1)
  | TILDE               -> selectorCombinator("GENERAL_SIBLING", $1)
  ;
Selector
  : ASTERISK            -> selectorComponent(UNIVERSAL_SELECTOR, $1)
  | SelectorAttr        -> selectorComponent(ATTR_SELECTOR, $1)
  | SelectorPseudoClass         -> selectorComponent(PSEUDO_CLASS, $1)
  | SelectorPseudoElement       -> selectorComponent(PSEUDO_ELEMENT, $1)
  | HASH_STRING         -> selectorComponent(ID_SELECTOR, { type: 'HASH', value: $1 })
  | HEXA_NUMBER         -> selectorComponent(ID_SELECTOR, { type: 'HASH', value: $1 })
  | ASTERISK_WITH_WHITESPACE        -> selectorComponent(UNIVERSAL_SELECTOR, $1.trimRight(), selectorCombinator("DESCENDANT", $1))
  | GENERAL_IDENT                   -> selectorComponent(TYPE_SELECTOR, vendorPrefixIdVal($1), selectorCombinator("DESCENDANT", $1))
  | VENDOR_PREFIX_IDENT             -> selectorComponent(TYPE_SELECTOR, vendorPrefixIdVal($1), selectorCombinator("DESCENDANT", $1))
  | SELECTOR_TYPE_WITH_WHITESPACE   -> selectorComponent(TYPE_SELECTOR, $1.trimRight(), selectorCombinator("DESCENDANT", " "))
  | SELECTOR_CLASS_WITH_WHITESPACE  -> selectorComponent(CLASS_SELECTOR, $1.trimRight(), selectorCombinator("DESCENDANT", " "))
  | SELECTOR_ID_WITH_WHITESPACE     -> selectorComponent(ID_SELECTOR, { type: 'HASH', value: $1.trimRight() }, selectorCombinator("DESCENDANT", " "))
  ;
SelectorAttr
  : LEFT_SQUARE_BRACKET IDENT SelectorAttrOperator GenericVal RIGHT_SQUARE_BRACKET
    %{
      $$ = {
        attribute: $2,
        operator: $3,
        value: $4
      }
    }%
  | LEFT_SQUARE_BRACKET IDENT RIGHT_SQUARE_BRACKET
    %{
      $$ = {
        attribute: $2
      }
    }%
  ;
SelectorAttrOperator
  : INCLUDE_MATCH       -> defVariable('include', $1)
  | DASH_MATCH	        -> defVariable('dash', $1)
  | PREFIX_MATCH        -> defVariable('prefix', $1)
  | SUFFIX_MATCH        -> defVariable('suffix', $1)
  | SUBSTRING_MATCH     -> defVariable('substring', $1)
  | ASSIGN_MARK         -> defVariable('equal', $1)
  ;
SelectorPseudoElement
  : COLON COLON IdentVal
    %{
      $$ = $3
      $$.prefix = $1 + $2
      $$.fullQuailfied = $$.prefix + $$.fullQuailfied
    }%
  ;

SelectorPseudoClassList
  : SelectorPseudoClass                   -> [defVariable(PSEUDO_CLASS, $1)]
  | SelectorPseudoClassList SelectorPseudoClass   -> merge($1, defVariable(PSEUDO_CLASS, $1))
  ;
SelectorPseudoClass
  : COLON IDENT               -> { fullQuailfied: $1 + $2, name: $2 }
  | COLON PseudoClassFunc     -> { fullQuailfied: $1 + $2.name, name: $2 }
  ;

PseudoClassFunc
  : FUNCTION RIGHT_PARENTHESIS              -> { type: "FUNCTION", name: $1 }
  | FUNCTION PseudoClassFuncParam RIGHT_PARENTHESIS   -> { type: "FUNCTION", name: $1, parameters: $2 }
  ;
PseudoClassFuncParams
  : PseudoClassFuncParam                            -> [$1]
  | PseudoClassFuncParams PseudoClassFuncParam      -> merge($1, $2)
  ;
PseudoClassFuncParam
  : SelectorGroupVal
  | PseudoClassFuncParam_an_plus_b
  ;
PseudoClassFuncParam_an_plus_b
  : N                                     /* n */
  | N PLUS_SIGN NUMBER                    /* n + 1 */
  | HYPHEN_MINUS N PLUS_SIGN NUMBER       /* -n + 1 */
  | NUMBER                                /* 1 */
  | HYPHEN_MINUS N                        /* 2n or -2n */
  | HYPHEN_MINUS NUMBER N                 /* -n + 1 */
  ;

/********************
** CALC()
********************/
CalcFuncVal
  : CALC_FUNC RIGHT_PARENTHESIS                   -> { type: FUNCTION, name: 'calc' }
  | CALC_FUNC CalcExpr RIGHT_PARENTHESIS          -> { type: FUNCTION, name: 'calc', expressions: $2 }
  ;
CalcExpr
  : GenericNumericVal
  | CalcExpr CalcOperator GenericNumericVal
    %{
      $$ = {
        type: CALC_EXPRESSION,
        leftHandSide: $1,
        operator: $2,
        rightHandSide: $3
      }
    }%
  ;
CalcOperator
  : ASTERISK
  | ASTERISK_WITH_WHITESPACE    -> $1.trimRight()
  | PLUS_SIGN
  | HYPHEN_MINUS
  | SOLIDUS
  ;

/********************
** VALUES
********************/
DeclarationPropValLists
  : DeclarationPropValList
  | DeclarationPropValLists COMMA DeclarationPropValList    -> merge($1, $3)
  ;
DeclarationPropValList
  : DeclarationPropVals -> multiDimesionsVal($1)
  ;
DeclarationPropVals
  : DeclarationPropVal                       -> $1
  | DeclarationPropVals DeclarationPropVal   -> merge($1, $2)
  | DeclarationPropVals CalcOperator DeclarationPropVal
    %{
      $$ = {
        type: CALC_EXPRESSION,
        leftHandSide: $1,
        operator: $2,
        rightHandSide: $3
      }
    }%
  ;
DeclarationPropVal
  : StringVal
  | UrlVal
  | IdentVal
  | FuncVal
  | GenericNumericVal
  | HashVal
  | CalcFuncVal
  ;
DeclarationPropName
  : IdentVal
  | ASTERISK IdentVal                   ->  addProp($2, 'asteriskHack', true)
  | ASTERISK_WITH_WHITESPACE IdentVal   ->  addProp($2.trimRight(), 'asteriskHack', true)
  ;

StringVal
  : STRING    -> { type: 'STRING', value: $1 }
  ;
UrlVal
  : URL_FUNC       -> { type: 'URL', value: $1 }
  ;
IdentVal
  : IDENT                -> vendorPrefixIdVal($1)
  ;
HashVal
  : HASH_STRING                   -> { type: 'HASH', value: $1 }
  | HEXA_NUMBER                   -> { type: 'HASH', value: $1 }
  | SELECTOR_ID_WITH_WHITESPACE   -> { type: 'HASH', value: $1.trimRight() }
  ;
PercentageVal
  : PERCENTAGE    -> percentageVal($1)
  ;
UrlOrStringVal
  : StringVal
  | UrlVal
  ;
IdOrUrlOrStringVal
  : StringVal
  | UrlVal
  | IdentVal
  ;
NumberVal
  : NUMBER        -> { type: NUMBER, value: parseFloat($1) }
  ;
DimensionVal
  : DIMENSION     -> demensionUnitVal($1)
  ;
GenericNumericVal
  : NumberVal
  | DimensionVal
  | PercentageVal
  ;
NumericVal
  : GenericNumericVal
  | HexaNumericVal
  ;
GenericVal
  : IdOrUrlOrStringVal
  | NumericVal
  ;

/********************
** MISC.
********************/
IDENT
  : GENERAL_IDENT
  | VENDOR_PREFIX_IDENT
  | SELECTOR_TYPE_WITH_WHITESPACE   -> $1.trimRight()
  ;
ComponentName
  : IDENT                           -> vendorPrefixIdVal($1)
  ;

FuncVal
  : FUNCTION RIGHT_PARENTHESIS              -> { type: FUNCTION, name: $1 }
  | FUNCTION FuncParams RIGHT_PARENTHESIS   -> { type: FUNCTION, name: $1, parameters: $2 }
  ;
FUNCTION
  : IDENT LEFT_PARENTHESIS          -> $1
  | OPERATOR_NOT LEFT_PARENTHESIS   -> $1
  ;
FuncParams
  : DeclarationPropVals                    -> [$1]
  | FuncParams COMMA DeclarationPropVals   -> merge($1, $3)
  ;


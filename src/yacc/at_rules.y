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
  : AT_CHARSET StringVal     -> atRule($1, $2)
  ;
at_rule_import
  : AT_IMPORT UrlOrStringVal                              -> atRule($1, $2)
  | AT_IMPORT UrlOrStringVal MediaQueryList             -> atRule($1, $2, 'mediaQueries', $3)
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
  : AT_MEDIA MediaQueryList   -> atRule($1, null, 'mediaQueries', $2)
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
  : keyframes_selector DeclarationList       -> keyframesVal($1, $2)
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
  : at_rule_page_frontpart DeclarationList   -> addProp($1, 'value', $2)
  ;

at_rule_page_frontpart
  : AT_PAGE                   -> atRule($1, null)
  | AT_PAGE SelectorPseudoClassList   -> atRule($1, null, 'pseudoClasses', $2)
  ;

at_rule_document
  : AT_DOCUMENT AtDocumentFuncValList -> atRule($1, null, 'value', functionVal($2))
  ;
AtDocumentFuncValList
  : AtDocumentFuncVal
  | AtDocumentFuncValList COMMA AtDocumentFuncVal   -> merge($1, $3)
  ;
AtDocumentFuncVal
  : URL_FUNC            -> functionVal('url', $1)
  | URL_PREFIX_FUNC     -> functionVal('url-prefix', $1)
  | DOMAIN_FUNC         -> functionVal('domain', $1)
  | REGEXP_FUNC         -> functionVal('regexp', $1)
  ;

at_rule_font_face
  : AT_FONT_FACE DeclarationList   -> { type: FONT_FACE, value: $2 }
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

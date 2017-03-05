/********************
** AT RULES
**
** referenced rules is on MDN[1].
**
** [1] https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule
********************/

RuleList
  : RuleListComponent                   -> [$1]
  | RuleListComponent RuleList         -> concat($1, $2)
  ;

RuleListComponent
  : QualifiedRule
  | AtRule
  ;

RuleBlock
  : LEFT_CURLY_BRACKET RuleList RIGHT_CURLY_BRACKET          -> $2
  | LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET                   -> null
  ;

AtRule
  : AtSimpleRules SEMICOLON
  | AtNestedRule
  | AtFontface
  | AtKeyframes
  | AtPage
  ;

AtSimpleRules
  : AtRuleCharset
  | AtImport
  | AtNamespace
  ;

AtRuleCharset
  : AT_CHARSET StringVal     -> AtCharset.create($1).set('value', $2)
  ;
AtImport
  : AT_IMPORT UrlOrStringVal                  -> AtImport.create($1).set('value', $2)
  | AT_IMPORT UrlOrStringVal MediaQueryList   -> AtImport.create($1).set('value', $2).set('nextExpression', $3)
  ;
AtNamespace
  : AT_NAMESPACE UrlOrStringVal               -> AtNamespace.create($1).set('value', $2)
  | AT_NAMESPACE IDENT UrlOrStringVal         -> AtNamespace.create($1).set('prefix', $2).set('value', $3)
  ;

AtNestedRule
  : AtNestedRuleComponent RuleBlock -> $1.set('nestedRules', $2)
  ;

AtNestedRuleComponent
  : AtMedia
  | AtDocument
  | AtSupport
  ;

AtMedia
  : AT_MEDIA MediaQueryList   -> AtMedia.create($1).set('value', $2)
  ;

AtKeyframes
  : AT_KEYFRAMES AtKeyframesName LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET                        -> AtKeyframes.create($1).set('name', $2)
  | AT_KEYFRAMES AtKeyframesName LEFT_CURLY_BRACKET AtKeyframesBlockList RIGHT_CURLY_BRACKET   -> AtKeyframes.create($1).set('name', $2).set('value', $4)
  ;
AtKeyframesBlockList
  : AtKeyframesBlock                        -> AtKeyframesBlockList.create().add($1)
  | AtKeyframesBlockList AtKeyframesBlock   -> $1.add($2)
  ;
AtKeyframesBlock
  : AtKeyframesSelector DeclarationList       -> AtKeyframesBlock.create($1).set('value', $2)
  ;
AtKeyframesName
  : IdentVal
  | StringVal
  ;
AtKeyframesSelector
  : IdentVal
  | PercentageVal
  ;

/* TODO: I don't understand @page rules deeply. */
AtPage
  : AtPageComponent DeclarationList   -> $1.set('nestedRules', $2)
  ;

AtPageComponent
  : AT_PAGE                           -> AtPage.create($1)
  | AT_PAGE PseudoClassSelectorList   -> AtPage.create($1).set('value', $2)
  ;

AtDocument
  : AT_DOCUMENT AtDocumentFuncValList -> AtDocument.create($1).set('value', $2)
  ;
AtDocumentFuncValList
  : AtDocumentFuncVal                               -> concat($1, [])
  | AtDocumentFuncValList COMMA AtDocumentFuncVal   -> concat($1, $3)
  ;
AtDocumentFuncVal
  : URL_FUNC            -> FunctionVal.create('url', $1)
  | URL_PREFIX_FUNC     -> FunctionVal.create('url-prefix', $1)
  | DOMAIN_FUNC         -> FunctionVal.create('domain', $1)
  | REGEXP_FUNC         -> FunctionVal.create('regexp', $1)
  ;

AtFontface
  : AT_FONT_FACE DeclarationList   -> AtFontface.create($1).set('value', $2)
  ;

/* TODO: I don't understand @supports rules deeply. */
AtSupport
  : AT_SUPPORTS AtSupportExpressionList   -> AtSupport.create($1).set('value', $2)
  ;

AtSupportExpressionList
  : AtSupportExpression
  | AtSupportExpressionList AndOrOperator AtSupportExpression
    %{
      $$ = $1
      $1.set('nextExpression', $2)
      $2.set('nextExpression', $3)
    }%
  ;
AtSupportExpression
  : AtSupportExpressionComponent
  | OPERATOR_NOT AtSupportExpressionComponent     -> $2.set('operator', $1)
  ;
AndOrOperator
  : OPERATOR_AND      -> Operator.create($1)
  | OPERATOR_OR       -> Operator.create($1)
  ;
AtSupportExpressionComponent
  : LEFT_PARENTHESIS PropertyName COLON PropertyValue RIGHT_PARENTHESIS   -> AtSupportExpression.create().set('property', $2).set('value', $4)
  ;

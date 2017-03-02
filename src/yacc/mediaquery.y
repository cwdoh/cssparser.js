/********************
** MEDIA QUERY
**
** referenced rules is on MDN[1].
**
** [1] https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries#Pseudo-BNF
********************/

MediaQueryList
  : MediaQueryGroup -> { type: MEDIA_QUERIES, value: $1 }
  ;

MediaQueryGroup
  : MediaQuery                             -> [$1]
  | MediaQuery COMMA MediaQueryGroup     -> $3.concat([$1])
  ;

MediaQuery
  : IDENT                                                    -> mediaQuery(null, $1)
  | IDENT MediaQueryAndExpressionList                    -> mediaQuery(null, $1, $2)
  | OnlyNot IDENT                                  -> mediaQuery($1, $2)
  | OnlyNot IDENT MediaQueryAndExpressionList  -> mediaQuery($1, $2, $3)
  | MediaQueryExpressionList                              -> mediaQuery(null, null, $1)
  ;

OnlyNot
  : OPERATOR_ONLY
  | OPERATOR_NOT
  ;

MediaQueryExpressionList
  : MediaQueryExpression MediaQueryAndExpressionList      -> merge($1, $2)
  | MediaQueryExpression                                      -> [$1]
  ;

MediaQueryAndExpressionList
  : MediaQueryAndExpressionList MediaQueryAndExpression  -> merge($1, $2)
  | MediaQueryAndExpression                                  -> [$1]
  ;

MediaQueryAndExpression
  : OPERATOR_AND MediaQueryExpression              -> addProp($2, 'operator', $1)
  ;

MediaQueryExpression
  /* Basically we have to use MEDIA_FEATURE[1]. How do I treat non-error cases such as unknown features?
   * [1] https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries#Pseudo-BNF
   */
  : LEFT_PARENTHESIS MediaFeature RIGHT_PARENTHESIS                      -> mediaQueryExpr($2)
  | LEFT_PARENTHESIS MediaFeature COLON GenericVal RIGHT_PARENTHESIS     -> mediaQueryExpr($2, $4)
  ;

MediaFeature
  : IdentVal
  ;

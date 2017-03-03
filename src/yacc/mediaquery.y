/********************
** MEDIA QUERY
**
** referenced rules is on MDN[1].
**
** [1] https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries#Pseudo-BNF
********************/

MediaQueryList
  : MediaQuery                          -> MediaQueryList.create().add($1)
  | MediaQueryList COMMA MediaQuery     -> $1.add($3)
  ;

MediaQuery
  : MediaQueryExpressionList
  | IdentVal                     -> MediaQuery.create().set('mediaType', $1)
  | OnlyNot IdentVal             -> MediaQuery.create().set('prefix', $1).set('mediaType', $2)
  | IdentVal And MediaQueryExpressionList
    %{
      $$ = MediaQuery.create().set('mediaType', $1)
      $$.set('nextExpression', $2)
      $2.set('nextExpression', $3)
    }%
  | OnlyNot IdentVal And MediaQueryExpressionList
    %{
      $$ = MediaQuery.create().set('prefix', $1).set('mediaType', $2)
      $$.set('nextExpression', $3)
      $3.set('nextExpression', $4)
    }%
  ;

OnlyNot
  : OPERATOR_ONLY
  | OPERATOR_NOT
  ;

And
  : OPERATOR_AND      -> Operator.create($1)
  ;

MediaQueryExpressionList
  : MediaQueryExpression
  | MediaQueryExpression And MediaQueryExpressionList
    %{
      $$ = $1
      $1.set("nextExpression", $2)
      $2.set("nextExpression", $3)
    }%
  ;

MediaQueryExpression
  /* Basically we have to use MEDIA_FEATURE[1]. How do I treat non-error cases such as unknown features?
   * [1] https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries#Pseudo-BNF
   */
  : LEFT_PARENTHESIS MediaFeature RIGHT_PARENTHESIS                      -> MediaQueryExpression.create($2)
  | LEFT_PARENTHESIS MediaFeature COLON GenericVal RIGHT_PARENTHESIS     -> MediaQueryExpression.create($2, $4)
  ;

MediaFeature
  : IdentVal
  ;

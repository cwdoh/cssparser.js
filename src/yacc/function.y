/********************
** GENERIC FUNCTION
********************/
FunctionVal
  : FUNCTION RIGHT_PARENTHESIS                      -> FunctionVal.create($1)
  | FUNCTION FunctionParameters RIGHT_PARENTHESIS   -> FunctionVal.create($1, $2)
  ;

FUNCTION
  : IdentVal LEFT_PARENTHESIS
  | OPERATOR_NOT LEFT_PARENTHESIS     -> IdentVal.create($1)
  ;

FunctionParameters
  : PropertyValue                               -> $1
  | IDENT ASSIGN_MARK GenericNumericVal         -> Expression.create($2, $1, $3)    /* same as `Expression.create().set('operator', $2).set('lhs', $1).set('rhs', $3)` */
  ;

/********************
** CALC() FUNCTION
********************/
CalcFunction
  : CALC_FUNC RIGHT_PARENTHESIS                         -> FunctionVal.create('calc')
  | CALC_FUNC CalcExpression RIGHT_PARENTHESIS          -> FunctionVal.create('calc', $2)
  ;
CalcExpression
  : GenericNumericVal
  | CalcExpression CalcOperator GenericNumericVal       -> Expression.create($2, $1, $3)    /* same as `Expression.create().set('operator', $2).set('lhs', $1).set('rhs', $3)` */
  ;
CalcOperator
  : ASTERISK
  | ASTERISK_WITH_WHITESPACE    -> $1.trimRight()
  | PLUS_SIGN
  | HYPHEN_MINUS
  | SOLIDUS
  ;
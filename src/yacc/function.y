/********************
** GENERIC FUNCTION
********************/
FunctionVal
  : FUNCTION RIGHT_PARENTHESIS                      -> functionVal($1)
  | FUNCTION FunctionParameters RIGHT_PARENTHESIS   -> functionVal($1, $2)
  ;

FUNCTION
  : IDENT LEFT_PARENTHESIS
  | OPERATOR_NOT LEFT_PARENTHESIS
  ;

FunctionParameters
  : PropertyValueItem                                 -> [$1]
  | FunctionParameters COMMA PropertyValueItem        -> merge($1, $3)
  | IDENT ASSIGN_MARK GenericNumericVal             -> [operationVal($2, $1, $3)]
  ;

/********************
** CALC() FUNCTION
********************/
CalcFunction
  : CALC_FUNC RIGHT_PARENTHESIS                         -> functionVal('calc')
  | CALC_FUNC CalcExpression RIGHT_PARENTHESIS          -> functionVal('calc', $2)
  ;
CalcExpression
  : GenericNumericVal
  | CalcExpression CalcOperator GenericNumericVal       -> operationVal($2, $1, $3)
  ;
CalcOperator
  : ASTERISK
  | ASTERISK_WITH_WHITESPACE    -> $1.trimRight()
  | PLUS_SIGN
  | HYPHEN_MINUS
  | SOLIDUS
  ;
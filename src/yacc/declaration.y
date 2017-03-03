/********************
** DECLARATION
********************/

PropertyName
  : IdentVal
  | ASTERISK IdentVal                   ->  $2.set('asteriskHack', true)
  | ASTERISK_WITH_WHITESPACE IdentVal   ->  $2.set('asteriskHack', true)
  ;
PropertyValue
  : PropertyValueItemSequence
  | PropertyValue COMMA PropertyValueItemSequence    -> concat($1, $3)
  ;
PropertyValueItemSequence
  : PropertyValueItem -> SequenceVal.create($1)
  ;
PropertyValueItem
  : GenericPropertyValueItem
  | PropertyValueItem GenericPropertyValueItem                -> concat($1, $2)
  /* FIXME: Make expression more clear */
  | PropertyValueItem CalcOperator GenericPropertyValueItem   -> Expression.create().set('operator', $2).set('lhs', $1).set('rhs', $3)
  ;
GenericPropertyValueItem
  : StringVal
  | UrlVal
  | IdentVal
  | FunctionVal
  | GenericNumericVal
  | HashVal
  | CalcFunction
  ;

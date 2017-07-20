/********************
** DECLARATION
********************/

PropertyName
  : IdentVal
  ;
PropertyValue
  : PropertyValueComponent
  | PropertyValue COMMA PropertyValueComponent    -> concat($1, $3)
  ;

PropertyValueComponent
  : SinglePropertyValue
  | SequencialPropertyValue
  ;
SequencialPropertyValue
  : SinglePropertyValue SinglePropertyValue         -> SequenceVal.create($1).add($2)
  | SequencialPropertyValue SinglePropertyValue     -> $1.add($2)
  ;
SinglePropertyValue
  : GenericPropertyValue
  | GenericPropertyValue CalcOperator SinglePropertyValue         -> Expression.create().set('operator', $2).set('lhs', $1).set('rhs', $3)
  ;
GenericPropertyValue
  : StringVal
  | UrlVal
  | IdentVal
  | FunctionVal
  | GenericNumericVal
  | HashVal
  | CalcFunction
  ;

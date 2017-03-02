/********************
** DECLARATION
********************/

PropertyName
  : IdentVal
  | ASTERISK IdentVal                   ->  addProp($2, 'asteriskHack', true)
  | ASTERISK_WITH_WHITESPACE IdentVal   ->  addProp($2.trimRight(), 'asteriskHack', true)
  ;
PropertyValue
  : PropertyValueItemSequence
  | PropertyValue COMMA PropertyValueItemSequence    -> merge($1, $3)
  ;
PropertyValueItemSequence
  : PropertyValueItem -> sequencialVal($1)
  ;
PropertyValueItem
  : GenericPropertyValueItem                              -> $1
  | PropertyValueItem GenericPropertyValueItem                -> merge($1, $2)
  | PropertyValueItem CalcOperator GenericPropertyValueItem
    %{
      $$ = {
        type: EXPRESSION,
        lhs: $1,
        operator: $2,
        lhs: $3
      }
    }%
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

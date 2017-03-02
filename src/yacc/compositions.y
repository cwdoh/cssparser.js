/********************
** COMPOSITIONS
********************/
UrlOrStringVal
  : StringVal
  | UrlVal
  ;
IdOrUrlOrStringVal
  : StringVal
  | UrlVal
  | IdentVal
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

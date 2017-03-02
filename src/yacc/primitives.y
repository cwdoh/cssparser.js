/********************
** PRIMITIVES
********************/

NumberVal
  : NUMBER        -> numberVal($1)
  ;
DimensionVal
  : DIMENSION     -> dimensionUnitVal($1)
  ;
StringVal
  : STRING    -> stringVal($1)
  ;
UrlVal
  : URL_FUNC       -> urlVal($1)
  ;
IdentVal
  : IDENT                -> vendorPrefixIdVal($1)
  ;
HashVal
  : HASH_STRING                   -> hashVal($1)
  | HEXA_NUMBER                   -> hashVal($1)
  | SELECTOR_ID_WITH_WHITESPACE   -> hashVal($1.trimRight())
  ;
PercentageVal
  : PERCENTAGE    -> percentageVal($1)
  ;

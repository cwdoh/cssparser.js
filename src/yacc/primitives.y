/********************
** PRIMITIVES
********************/

NumberVal
  : NUMBER        -> NumberVal.create($1)
  ;
StringVal
  : STRING        -> StringVal.create($1)
  ;
DimensionVal
  : DIMENSION     -> DimensionVal.create($1)
  ;
UrlVal
  : URL_FUNC      -> UrlVal.create($1)
  ;
IdentVal
  : IDENT         -> IdentVal.create($1)
  ;
HashVal
  : HASH_STRING                   -> HashVal.create($1)
  | HEXA_NUMBER                   -> HashVal.create($1)
  | SELECTOR_ID_WITH_WHITESPACE   -> HashVal.create($1.trimRight())
  ;
PercentageVal
  : PERCENTAGE    -> PercentageVal.create($1)
  ;

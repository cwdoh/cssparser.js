/********************
** MISC.
********************/
IDENT
  : GENERAL_IDENT
  | VENDOR_PREFIX_IDENT
  | SELECTOR_TYPE_WITH_WHITESPACE   -> $1.trimRight()
  ;

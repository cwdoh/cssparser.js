/********************
** ROOT Nodes
********************/

stylesheet
  : StylesheetList EOF
    {
      return $1
    }
  | EOF
    {
      return StyleSheet.create()
    }
  ;

StylesheetList
  : StylesheetComponent                   -> StyleSheet.create().add($1)
  | StylesheetList StylesheetComponent    -> $1.add($2)
  ;

StylesheetComponent
  : CDO
  | CDC
  | QualifiedRule
  | AtRule
  ;

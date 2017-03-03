/********************
** ROOT Nodes
********************/

stylesheet
  : StylesheetList EOF
    %{
      console.log(JSON.stringify($1.toJSON(), null, 4))
      $$ = $1
    }%
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

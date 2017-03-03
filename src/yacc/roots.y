/********************
** ROOT Nodes
********************/

stylesheet
  : stylesheet_list EOF
    %{
      console.log(JSON.stringify($1, null, '\t'))
      $$ = $1
    }%
  ;

stylesheet_list
  : stylesheet_component                    -> StyleSheet.create().add($1)
  | stylesheet_list stylesheet_component    -> $1.add($2)
  ;

stylesheet_component
  : CDO
  | CDC
  | QualifiedRule
  | at_rule
  ;

rule_list
  : rule_list_component                   -> [$1]
  | rule_list_component rule_list         -> concat($1, $2)
  ;

rule_list_component
  : QualifiedRule
  | at_rule
  ;

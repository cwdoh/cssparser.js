/********************
** ROOT Nodes
********************/

stylesheet
  : stylesheet_list EOF
    %{
      $$ = {
        type: 'STYLESHEET',
        value: $1
      }

      return $$
    }%
  ;

stylesheet_list
  : stylesheet_component
    %{
      $$ = []
      if ($1)
        $$.push($1)
    }%
  | stylesheet_component stylesheet_list
    %{
      if ($1 == null) {
        $$ = $2
        return
      }

      $$ = [$1].concat($2)
    }%
  ;

stylesheet_component
  : CDO             -> $1
  | CDC             -> $1
  | QualifiedRule   -> $1
  | at_rule         -> $1
  ;

rule_list
  : rule_list_component                   -> [$1]
  | rule_list_component rule_list         -> [$1].concat($2)
  ;

rule_list_component
  : QualifiedRule    -> $1
  | at_rule           -> $1
  ;

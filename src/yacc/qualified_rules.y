/********************
** QUALIFIED RULES
**
** referenced rules is on MDN[1].
**
** [1] https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule
********************/

QualifiedRule
  : SelectorList DeclarationList
    %{
        $$ = {
          type: CSS_RULE,
          selectors: $1,
          value: $2
        }
    }%
  ;

DeclarationList
  : LEFT_CURLY_BRACKET Declaration RIGHT_CURLY_BRACKET     -> declarations(merge($2, []))
  | LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET                 -> []
  ;
Declaration
  : DeclarationComponent
  | DeclarationComponent SEMICOLON
  | DeclarationComponent SEMICOLON Declaration    -> merge($1, $3)
  ;
DeclarationComponent
  : PropertyName COLON PropertyValue IMPORTANT   -> cssDeclarationVal($1, $3, $4)
  | PropertyName COLON PropertyValue             -> cssDeclarationVal($1, $3)
  ;

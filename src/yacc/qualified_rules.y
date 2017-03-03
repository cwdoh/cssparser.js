/********************
** QUALIFIED RULES
**
** referenced rules is on MDN[1].
**
** [1] https://developer.mozilla.org/en-US/docs/Web/CSS/At-rule
********************/

QualifiedRule
  : SelectorList DeclarationList    -> QualifiedRule.create($2).set('selectors', $1)
  ;

DeclarationList
  : LEFT_CURLY_BRACKET Declaration RIGHT_CURLY_BRACKET     -> DeclarationList.create($2)
  | LEFT_CURLY_BRACKET RIGHT_CURLY_BRACKET                 -> DeclarationList.create()
  ;
Declaration
  : DeclarationComponent
  | DeclarationComponent SEMICOLON
  | DeclarationComponent SEMICOLON Declaration    -> concat($1, $3)
  ;
DeclarationComponent
  : PropertyName COLON PropertyValue IMPORTANT   -> Declaration.create($1, $3).set('important', true)
  | PropertyName COLON PropertyValue             -> Declaration.create($1, $3)
  ;

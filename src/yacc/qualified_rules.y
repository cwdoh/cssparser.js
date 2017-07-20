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
  : DeclarationMandatoryComponent
  | DeclarationMandatoryComponent IMPORTANT   -> $1.set('important', true)
  ;

DeclarationMandatoryComponent
  : DeclarationMandatoryPart
  | DeclarationMandatoryPartWithIEHack    -> $1.set('ieOnlyHack', true)
  ;

DeclarationMandatoryPartWithIEHack
  : ASTERISK DeclarationMandatoryPart                   -> $2.set('asteriskHack', true)
  | ASTERISK_WITH_WHITESPACE DeclarationMandatoryPart   -> $2.set('asteriskHack', true)
  | UNDERSCORE DeclarationMandatoryPart                 -> $2.set('underscoreHack', true)
  | DeclarationMandatoryPart REVERSE_SOLIDUS NUMBER     -> $1.set('backslashHack', true)
  ;

DeclarationMandatoryPart
  : PropertyName COLON PropertyValue                    -> Declaration.create($1, $3)
  ;
  
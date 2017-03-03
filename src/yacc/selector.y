/********************
 * CSS Selector
 *
 * ref. [1] https://developer.mozilla.org/en-US/docs/Learn/CSS/Introduction_to_CSS/Combinators_and_multiple_selectors
 *      [2] https://www.w3.org/TR/css3-selectors/#combinators
 */


SelectorList
  : SelectorGroup                        -> SelectorList.create().add(RootSelector.create($1))
  | SelectorList COMMA SelectorGroup     -> $1.add(RootSelector.create($3))
  ;
SelectorGroup
  : Selector
  | Selector SelectorGroup
    %{
      $$ = $1
      $1.set('nextSelector', $2)
    }%
  | Selector SelectorCombinator SelectorGroup
    %{
      $$ = $1
      $1.set('nextSelector', $2)
      $2.set('nextSelector', $3)
    }%
  | DescendantSelector
  | DescendantSelector SelectorGroup
    %{
      var combinator = DescendantSelectorCombinator.create(' ')

      // $1 -> combinator -> $2
      $$ = $1
      $$.set('nextSelector', combinator)
      combinator.set('nextSelector', $2)
    }%
  | DescendantSelector SelectorCombinator SelectorGroup
    %{
      $$ = $1
      $1.set('nextSelector', $2)
      $2.set('nextSelector', $3)
    }%
  ;
SelectorCombinator
  : GREATER_THAN_SIGN   -> ChildSelectorCombinator.create($1)
  | PLUS_SIGN           -> AdjacentSiblingSelectorCombinator.create($1)
  | TILDE               -> SiblingSelectorCombinator.create($1)
  ;
Selector
  : UniversalSelector
  | ClassSelector
  | TypeSelector
  | IdSelector
  | SelectorAttr
  | SelectorPseudoClass     -> selectorComponent(PSEUDO_CLASS, $1)
  | SelectorPseudoElement   -> selectorComponent(PSEUDO_ELEMENT, $1)
  ;
UniversalSelector
  : ASTERISK                -> UniversalSelector.create($1)
  ;
IdSelector
  : HASH_STRING             -> IdSelector.create(hashVal($1))
  | HEXA_NUMBER             -> IdSelector.create(hashVal($1))
  ;
TypeSelector
  : GENERAL_IDENT           -> TypeSelector.create($1)
  ;
ClassSelector
  : FULL_STOP IDENT                 -> ClassSelector.create($1 + $2)
  | FULL_STOP OPERATOR_AND          -> ClassSelector.create($1 + $2)
  | FULL_STOP OPERATOR_OR           -> ClassSelector.create($1 + $2)
  | FULL_STOP OPERATOR_ONLY         -> ClassSelector.create($1 + $2)
  | FULL_STOP OPERATOR_NOT          -> ClassSelector.create($1 + $2)
  ;
DescendantSelector
  : ASTERISK_WITH_WHITESPACE        -> UniversalSelector.create($1.trimRight())
  | SELECTOR_TYPE_WITH_WHITESPACE   -> TypeSelector.create($1.trimRight())
  | SELECTOR_CLASS_WITH_WHITESPACE  -> ClassSelector.create($1.trimRight())
  | SELECTOR_ID_WITH_WHITESPACE     -> IdSelector.create(hashVal($1.trimRight()))
  ;
SelectorAttr
  : LEFT_SQUARE_BRACKET IDENT SelectorAttrOperator GenericVal RIGHT_SQUARE_BRACKET
    %{
      $$ = {
        type: ATTRIBUTE,
        value: $2,
        expression: {
          type: EXPRESSION,
          operator: $3,
          value: $4
        }
      }
    }%
  | LEFT_SQUARE_BRACKET IDENT RIGHT_SQUARE_BRACKET
    %{
      $$ = selectorComponent(ATTR_SELECTOR, {
        type: ATTRIBUTE,
        value: $2
      })
    }%
  ;
SelectorAttrOperator
  : INCLUDE_MATCH       -> defVariable('include', $1)
  | DASH_MATCH	        -> defVariable('dash', $1)
  | PREFIX_MATCH        -> defVariable('prefix', $1)
  | SUFFIX_MATCH        -> defVariable('suffix', $1)
  | SUBSTRING_MATCH     -> defVariable('substring', $1)
  | ASSIGN_MARK         -> defVariable('equal', $1)
  ;
SelectorPseudoElement
  : COLON COLON IdentVal
    %{
      $$ = $3
      $$.prefix = $1 + $2
    }%
  ;

SelectorPseudoClassList
  : SelectorPseudoClass                           -> [defVariable(PSEUDO_CLASS, $1)]
  | SelectorPseudoClassList SelectorPseudoClass   -> merge($1, defVariable(PSEUDO_CLASS, $1))
  ;
SelectorPseudoClass
  : COLON IDENT               -> { prefix: $1, name: $2 }
  | COLON PseudoClassFunc     -> { prefix: $1, name: $2 }
  ;

PseudoClassFunc
  : FUNCTION RIGHT_PARENTHESIS                        -> FunctionVal.create($1)
  | FUNCTION PseudoClassFuncParam RIGHT_PARENTHESIS   -> FunctionVal.create($1, $2)
  ;
PseudoClassFuncParam
  : SelectorGroup
  | PseudoClassFuncParam_an_plus_b
  ;
PseudoClassFuncParam_an_plus_b
  : N                                     /* n */
  | N PLUS_SIGN NUMBER                    /* n + 1 */
  | HYPHEN_MINUS N PLUS_SIGN NUMBER       /* -n + 1 */
  | NUMBER                                /* 1 */
  | DIMENSION                             /* 2n or -2n */
  | HYPHEN_MINUS NUMBER N                 /* -n + 1 */
  ;

/********************
 * CSS Selector
 *
 * ref. [1] https://developer.mozilla.org/en-US/docs/Learn/CSS/Introduction_to_CSS/Combinators_and_multiple_selectors
 *      [2] https://www.w3.org/TR/css3-selectors/#combinators
 */


SelectorList
  : SelectorGroup                        -> SelectorList.create().add($1)
  | SelectorList COMMA SelectorGroup     -> $1.add($3)
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
  | AttributeSelector
  | PseudoClassSelector
  | PseudoElementSelector
  ;
UniversalSelector
  : ASTERISK                -> UniversalSelector.create($1)
  ;
IdSelector
  : HASH_STRING             -> IdSelector.create(HashVal.create($1))
  | HEXA_NUMBER             -> IdSelector.create(HashVal.create($1))
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
  | SELECTOR_ID_WITH_WHITESPACE     -> IdSelector.create(HashVal.create($1.trimRight()))
  ;
AttributeSelector
  : LEFT_SQUARE_BRACKET IdentVal SelectorAttrOperator GenericVal RIGHT_SQUARE_BRACKET   -> AttributeSelector.create(Expression.create($3, $2, $4))
  | LEFT_SQUARE_BRACKET IdentVal RIGHT_SQUARE_BRACKET                                   -> AttributeSelector.create($2)
  ;
SelectorAttrOperator
  : INCLUDE_MATCH       -> Operator.create($1)		/* include   */
  | DASH_MATCH	        -> Operator.create($1)		/* dash      */
  | PREFIX_MATCH        -> Operator.create($1)		/* prefix    */
  | SUFFIX_MATCH        -> Operator.create($1)		/* suffix    */
  | SUBSTRING_MATCH     -> Operator.create($1)		/* substring */
  | ASSIGN_MARK         -> Operator.create($1)		/* equal     */
  ;
PseudoElementSelector
  : COLON COLON IdentVal   -> PseudoElementSelector.create($3)
  ;

PseudoClassSelectorList
  : PseudoClassSelector
  | PseudoClassSelector PseudoClassSelectorList   -> $1.set('nextSelector', $2)
  ;
PseudoClassSelector
  : COLON IdentVal            -> PseudoClassSelector.create($2)
  | COLON PseudoClassFunc     -> PseudoClassSelector.create($2)
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
  : N                                     -> $1             /* n */
  | N PLUS_SIGN NUMBER                    -> $1 + $2 + $3   /* n + 1 */
  | HYPHEN_MINUS N PLUS_SIGN NUMBER       -> $1 + $2 + $3   /* -n + 1 */
  | NUMBER                                -> $1             /* 1 */
  | DIMENSION                             -> $1             /* 2n or -2n */
  | HYPHEN_MINUS NUMBER N                 -> $1 + $2        /* -n + 1 */
  ;

/********************
 * CSS Selector
 *
 * ref. [1] https://developer.mozilla.org/en-US/docs/Learn/CSS/Introduction_to_CSS/Combinators_and_multiple_selectors
 *      [2] https://www.w3.org/TR/css3-selectors/#combinators
 */

SelectorList
  : SelectorGroup                        -> merge(defVariable(SELECTOR, removeTailingSelectorCombinator($1)), [])
  | SelectorList COMMA SelectorGroup     -> merge($1, defVariable(SELECTOR, removeTailingSelectorCombinator($3)))
  ;
SelectorGroup
  : Selector
  | Selector SelectorGroup
    %{
      $$ = $1
      $$.nextSelector = $2
    }%
  | Selector SelectorCombinator SelectorGroup
    %{
      $$ = $1
      $$.nextSelector = $2
      $$.nextSelector.nextSelector = $3
    }%
  | DescendantSelector
  | DescendantSelector SelectorGroup
    %{
      $$ = $1
      $$.nextSelector = selectorCombinator("DESCENDANT", " ")
      $$.nextSelector.nextSelector = $2
    }%
  | DescendantSelector SelectorCombinator SelectorGroup
    %{
      $$ = $1
      $$.nextSelector = $2
      $$.nextSelector.nextSelector = $3
    }%
  ;
SelectorCombinator
  : GREATER_THAN_SIGN   -> selectorCombinator("CHILD", $1)
  | PLUS_SIGN           -> selectorCombinator("ADJACENT_SIBLING", $1)
  | TILDE               -> selectorCombinator("GENERAL_SIBLING", $1)
  ;
Selector
  : ASTERISK                -> selectorComponent(UNIVERSAL_SELECTOR, $1)
  | SelectorAttr
  | SelectorPseudoClass     -> selectorComponent(PSEUDO_CLASS, $1)
  | SelectorPseudoElement   -> selectorComponent(PSEUDO_ELEMENT, $1)
  | HASH_STRING             -> selectorComponent(ID_SELECTOR, hashVal($1))
  | HEXA_NUMBER             -> selectorComponent(ID_SELECTOR, hashVal($1))
  | ClassSelector
  | GENERAL_IDENT           -> selectorComponent(TYPE_SELECTOR, vendorPrefixIdVal($1))
  | VENDOR_PREFIX_IDENT     -> selectorComponent(TYPE_SELECTOR, vendorPrefixIdVal($1))
  ;
ClassSelector
  : FULL_STOP IDENT                 -> selectorComponent(CLASS_SELECTOR, $1 + $2)
  | FULL_STOP OPERATOR_AND          -> selectorComponent(CLASS_SELECTOR, $1 + $2)
  | FULL_STOP OPERATOR_OR           -> selectorComponent(CLASS_SELECTOR, $1 + $2)
  | FULL_STOP OPERATOR_ONLY         -> selectorComponent(CLASS_SELECTOR, $1 + $2)
  | FULL_STOP OPERATOR_NOT          -> selectorComponent(CLASS_SELECTOR, $1 + $2)
  ;
DescendantSelector
  : ASTERISK_WITH_WHITESPACE        -> selectorComponent(UNIVERSAL_SELECTOR, $1.trimRight())
  | SELECTOR_TYPE_WITH_WHITESPACE   -> selectorComponent(TYPE_SELECTOR, $1.trimRight())
  | SELECTOR_CLASS_WITH_WHITESPACE  -> selectorComponent(CLASS_SELECTOR, $1.trimRight())
  | SELECTOR_ID_WITH_WHITESPACE     -> selectorComponent(ID_SELECTOR, hashVal($1.trimRight()))
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
  : FUNCTION RIGHT_PARENTHESIS                        -> functionVal($1)
  | FUNCTION PseudoClassFuncParam RIGHT_PARENTHESIS   -> functionVal($1, $2)
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

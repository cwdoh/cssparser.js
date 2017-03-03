%{
    @@include('../../dist/babel/node.js')
%}

%start stylesheet

%%

@@include('../yacc/roots.y')
@@include('../yacc/at_rules.y')
@@include('../yacc/declaration.y')
@@include('../yacc/function.y')
@@include('../yacc/mediaquery.y')
@@include('../yacc/qualified_rules.y')
@@include('../yacc/selector.y')
@@include('../yacc/primitives.y')
@@include('../yacc/compositions.y')
@@include('../yacc/misc.y')

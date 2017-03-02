/* lexical scanner from W3C spec. see http://www.w3.org/TR/css3-syntax/#lexical */
%lex
@@include('../lex/regexp.l')

%%
@@include('../lex/token.l')

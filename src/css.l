/* lexical scanner from W3C spec. see http://www.w3.org/TR/css3-syntax/#lexical */
%lex

comment                     \/\*[^*]*\*+([^/][^*]*\*+)*\/
whitespace                  \s
ws                          {whitespace}
hexdigit	                [0-9a-fA-F]
/*escape                    \\{hexdigit}{1,6}{whitespace}|\\[^{newline}|{hexdigit}]*/
escape	                	{unicode}|\\[ -~\200-\377]

nonascii                   	[\200-\377]
unicode	                    \\{h}{1,6}[ \t\r\n\f]?
nmstart             		[a-zA-Z]|{nonascii}|{escape}
nmchar		                [a-zA-Z0-9-]|{nonascii}|{escape}
identchar	                [_]|{nmchar}
ident                       [-]?{nmstart}{identchar}* 
sq_string	            	\"([\t !#$%&(-~]|\\{nl}|\'|{nonascii}|{escape})*\"
dq_string           		\'([\t !#$%&(-~]|\\{nl}|\"|{nonascii}|{escape})*\'
string                      {sq_string}|{dq_string}
url_unquoted	            ([!#$%&*-~]|{nonascii}|{escape})*
number			            ([\+\-]?[0-9]+(\.[0-9]+)?)|([\+\-]?\.[0-9]+)
range		                \?{1,6}|{h}(\?{0,5}|{h}(\?{0,4}|{h}(\?{0,3}|{h}(\?{0,2}|{h}(\??|{h})))))
string_func_body            \({ws}*({url_unquoted}|{string}){ws}*\)

vendor_prefix_body          "webkit"|"moz"|"o"|"ms"
vendor_prefix               [-]{vendor_prefix_body}[-]

operator_and                "and"
operator_or                 "or"
operator_only               "only"
operator_not                "not"
operators                   {operator_and}|{operator_or}|{operator_only}|{operator_not}

character_i                 "i"|"I"

%%
{hack}                              {function _token(tok) { /*console.log(tok);*/ return tok; }}
\/\*[^*]*\*+([^/][^*]*\*+)*\/		{}								/* ignore comment */

{whitespace}+                       {}

{vendor_prefix}{ident}              {return _token('VENDOR_PREFIX_IDENT');}

"calc"\(                            {return _token('CALC_FUNC');}

"url"{string_func_body}             {return _token('URL_FUNC');}
"url-prefix"{string_func_body}      {return _token('URL_PREFIX_FUNC');}
"domain"{string_func_body}          {return _token('DOMAIN_FUNC');}
"regexp"\({ws}*{string}{ws}*\)      {return _token('REGEXP_FUNC');}

"@charset"                          {return _token('AT_CHARSET');}
"@import"                           {return _token('AT_IMPORT');}
"@namespace"                        {return _token('AT_NAMESPACE');}
"@media"                            {return _token('AT_MEDIA');}
"@document"                         {return _token('AT_DOCUMENT');}
"@page"                             {return _token('AT_PAGE');}
"@supports"                         {return _token('AT_SUPPORTS');}
"@font-face"                        {return _token('AT_FONT_FACE');}
"@viewport"                         {return _token('AT_VIEWPORT');}
"@counter-style"                    {return _token('AT_COUNTER_STYLE');}
"@font-feature-values"              {return _token('AT_FONT_FEATURE_VALUES');}
"@"{vendor_prefix}?"keyframes"      {return _token('AT_KEYFRAMES');}
[@]{ident}                          {return _token('AT_KEYWORD');}

[.]{ident}{whitespace}+             {return _token('SELECTOR_CLASS_WITH_WHITESPACE');}
[#]{ident}{whitespace}+             {return _token('SELECTOR_ID_WITH_WHITESPACE');}

[#]{ident}                          {return _token('HASH_STRING');}
[#]{hexdigit}+                      {return _token('HEXA_NUMBER');}

{number}{ident}                     {return _token('DIMENSION');}               /* ref. https://developer.mozilla.org/en-US/docs/Web/CSS/length */
{number}"%"                         {return _token('PERCENTAGE');}
{number}                            {return _token('NUMBER');}

[Uu]\+{range}					    {return _token('UNICODE_RANGE');}

"~="								{return _token('INCLUDE_MATCH');}			/* includes */
"|="								{return _token('DASH_MATCH');}	    		/* dash match */
"^="								{return _token('PREFIX_MATCH');}			/* prefix match */
"$="								{return _token('SUFFIX_MATCH');}			/* suffix match */
"*="								{return _token('SUBSTRING_MATCH');}	    	/* substring match */

"||"								{return _token('COLUMN');}

"<!--"								{return _token('CDO');}					/* comment delimiter open */
"-->"								{return _token('CDC');}					/* comment delimiter close */

\=                                  {return _token('ASSIGN_MARK');}
\\									{return _token('QUOTATION_MARK');}
/*[#]                                 {return _token('HASH');}*/
\#									{return _token('NUMBER_SIGN');}
\$									{return _token('DOLLAR_SIGN');}
\‘									{return _token('APOSTROPHE');}
\(									{return _token('LEFT_PARENTHESIS');}
\)									{return _token('RIGHT_PARENTHESIS');}

[*]{whitespace}+                    {return _token('ASTERISK_WITH_WHITESPACE');}
[*]									{return _token('ASTERISK');}
\+									{return _token('PLUS_SIGN');}
\,									{return _token('COMMA');}
\-									{return _token('HYPHEN_MINUS');}
\.									{return _token('FULL_STOP');}
\/									{return _token('SOLIDUS');}
\:									{return _token('COLON');}
\;									{return _token('SEMICOLON');}
\<									{return _token('LESS_THAN_SIGN');}
\>									{return _token('GREATER_THAN_SIGN');}
\@									{return _token('COMMERCIAL_AT');}

\[									{return _token('LEFT_SQUARE_BRACKET');}
\\									{return _token('REVERSE_SOLIDUS');}
\]									{return _token('RIGHT_SQUARE_BRACKET');}
\^									{return _token('CIRCUMFLEX_ACCENT');}
\{									{return _token('LEFT_CURLY_BRACKET');}
\}									{return _token('RIGHT_CURLY_BRACKET');}
\|									{return _token('VERTICAL_LINE ');}
\~									{return _token('TILDE');}

{operators}{identchar}+              {return _token('GENERAL_IDENT');}
{media_type}{identchar}+             {return _token('GENERAL_IDENT');}
{media_feature}{identchar}+          {return _token('GENERAL_IDENT');}

/* reserved keywords */
{operator_and}                      {return _token('OPERATOR_AND');}
{operator_or}                       {return _token('OPERATOR_OR');}
{operator_only}                     {return _token('OPERATOR_ONLY');}
{operator_not}                      {return _token('OPERATOR_NOT');}

{string}                            {return _token('STRING');}

"n"{ident}                          {return _token('GENERAL_IDENT');}

"n"                                 {return _token('N');}

{ident}{whitespace}+                {return _token('SELECTOR_TYPE_WITH_WHITESPACE');}

{ident}                             {return _token('GENERAL_IDENT');}


"!important"                        {return _token('IMPORTANT');}

<<EOF>>                             {return _token('EOF');}

.								    {return _token(yytext);}

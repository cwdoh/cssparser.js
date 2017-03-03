comment                     \/\*[^*]*\*+([^/][^*]*\*+)*\/
whitespace                  \s
ws                          {whitespace}
hexdigit	                [0-9a-fA-F]
/*escape                    \\{hexdigit}{1,6}{whitespace}|\\[^{newline}|{hexdigit}]*/
escape	                	{unicode}|\\[ -~\200-\377]

alphabet                    [a-zA-Z]
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
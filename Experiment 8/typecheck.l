%{
#include "typecheck.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%

"int"           { return INT; }
"float"         { return FLOAT; }

[a-zA-Z_][a-zA-Z0-9_]*   {
                            yylval.str = strdup(yytext);
                            return ID;
                         }

[0-9]+          {
                    yylval.str = strdup(yytext);
                    return NUM;
                }

"="             { return '='; }
"+"             { return '+'; }
"-"             { return '-'; }
"*"             { return '*'; }
"/"             { return '/'; }
";"             { return ';'; }

[ \t\n]+        ;

.               { return yytext[0]; }

%%

int yywrap()
{
    return 1;
}
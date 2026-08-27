%{
#include "cal.tab.h"
#include <stdlib.h>
%}

DIGIT   [0-9]+

%option noyywrap

%%

{DIGIT}        {
                  yylval = atof(yytext);
                  return NUM;
               }

[ \t]          ;

\n             { return '\n'; }

.              { return yytext[0]; }

%%
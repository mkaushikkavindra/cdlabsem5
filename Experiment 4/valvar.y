%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
int yyerror(const char *s);
%}

%token LET DIG

%%

variable
        : var
        ;

var
        : LET
        | var LET
        | var DIG
        ;

%%

int main()
{
    printf("Enter the variable:\n");
    yyparse();
    printf("Valid variable\n");
    return 0;
}

int yyerror(const char *s)
{
    printf("Invalid variable\n");
    exit(0);
}
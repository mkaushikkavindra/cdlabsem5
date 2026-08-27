%{
#include <stdio.h>
#include <stdlib.h>

int yylex();
int yyerror(const char *s);
%}

%token ID DIG

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

stmt
        : expn
        ;

expn
        : expn '+' expn
        | expn '-' expn
        | expn '*' expn
        | expn '/' expn
        | '-' expn %prec UMINUS
        | '(' expn ')'
        | DIG
        | ID
        ;

%%

int main()
{
    printf("Enter the Expression\n");
    yyparse();
    printf("valid Expression\n");
    return 0;
}

int yyerror(const char *s)
{
    printf("Invalid Expression\n");
    exit(0);
}
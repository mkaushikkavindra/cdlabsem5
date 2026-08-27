%{
#include <stdio.h>
#include <stdlib.h>

#define YYSTYPE double

int yylex();
int yyerror(const char *s);
%}

%token NUM

%left '+' '-'
%left '*' '/'
%right UMINUS

%%

Statement
        : E '\n'
          {
              printf("Answer: %g\n", $1);
          }
        ;

E
        : E '+' E      { $$ = $1 + $3; }
        | E '-' E      { $$ = $1 - $3; }
        | E '*' E      { $$ = $1 * $3; }
        | E '/' E      { $$ = $1 / $3; }
        | '(' E ')'    { $$ = $2; }
        | '-' E %prec UMINUS { $$ = -$2; }
        | NUM          { $$ = $1; }
        ;

%%

int main()
{
    printf("Enter the expression:\n");
    yyparse();
    return 0;
}

int yyerror(const char *s)
{
    printf("%s\n", s);
    return 0;
}
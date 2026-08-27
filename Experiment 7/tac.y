%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
int yyerror(const char *s);

int tempCount = 1;
char temp[20];
%}

%union{
    char *str;
}

%token <str> ID NUM
%type <str> expr

%left '+' '-'
%left '*' '/'

%%

stmt
    : ID '=' expr
      {
          printf("%s = %s\n", $1, $3);
      }
    ;

expr
    : expr '+' expr
      {
          sprintf(temp,"t%d",tempCount++);
          printf("%s = %s + %s\n",temp,$1,$3);
          $$ = strdup(temp);
      }

    | expr '-' expr
      {
          sprintf(temp,"t%d",tempCount++);
          printf("%s = %s - %s\n",temp,$1,$3);
          $$ = strdup(temp);
      }

    | expr '*' expr
      {
          sprintf(temp,"t%d",tempCount++);
          printf("%s = %s * %s\n",temp,$1,$3);
          $$ = strdup(temp);
      }

    | expr '/' expr
      {
          sprintf(temp,"t%d",tempCount++);
          printf("%s = %s / %s\n",temp,$1,$3);
          $$ = strdup(temp);
      }

    | '(' expr ')'
      {
          $$ = $2;
      }

    | ID
      {
          $$ = $1;
      }

    | NUM
      {
          $$ = $1;
      }
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
    printf("Error: %s\n", s);
    return 0;
}
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int yylex();
int yyerror(const char *s);
%}

%union{
    char *str;
}

%token <str> ID NUM
%type <str> expr

%left '+' '-'
%left '*' '/'

%%

stmt_list
        : stmt_list stmt
        | stmt
        ;

stmt
        : ID '=' expr ';'
          {
              printf("%s = %s\n",$1,$3);
          }
        ;

expr
        : NUM
          {
              $$ = $1;
          }

        | ID
          {
              $$ = $1;
          }

        | expr '+' expr
          {
              if(isdigit($1[0]) && isdigit($3[0]))
              {
                  char buf[20];
                  sprintf(buf,"%d",atoi($1)+atoi($3));
                  $$ = strdup(buf);
                  printf("// Constant Folding: %s + %s -> %s\n",$1,$3,$$);
              }
              else if(strcmp($3,"0")==0)
              {
                  $$ = $1;
                  printf("// Algebraic Simplification: x + 0 -> x\n");
              }
              else if(strcmp($1,"0")==0)
              {
                  $$ = $3;
                  printf("// Algebraic Simplification: 0 + x -> x\n");
              }
              else
              {
                  char buf[50];
                  sprintf(buf,"%s + %s",$1,$3);
                  $$ = strdup(buf);
              }
          }

        | expr '-' expr
          {
              if(isdigit($1[0]) && isdigit($3[0]))
              {
                  char buf[20];
                  sprintf(buf,"%d",atoi($1)-atoi($3));
                  $$ = strdup(buf);
                  printf("// Constant Folding: %s - %s -> %s\n",$1,$3,$$);
              }
              else if(strcmp($3,"0")==0)
              {
                  $$ = $1;
                  printf("// Algebraic Simplification: x - 0 -> x\n");
              }
              else
              {
                  char buf[50];
                  sprintf(buf,"%s - %s",$1,$3);
                  $$ = strdup(buf);
              }
          }

        | expr '*' expr
          {
              if(isdigit($1[0]) && isdigit($3[0]))
              {
                  char buf[20];
                  sprintf(buf,"%d",atoi($1)*atoi($3));
                  $$ = strdup(buf);
                  printf("// Constant Folding: %s * %s -> %s\n",$1,$3,$$);
              }
              else if(strcmp($3,"1")==0)
              {
                  $$ = $1;
                  printf("// Algebraic Simplification: x * 1 -> x\n");
              }
              else if(strcmp($3,"2")==0)
              {
                  char buf[50];
                  sprintf(buf,"%s + %s",$1,$1);
                  $$ = strdup(buf);
                  printf("// Strength Reduction: x * 2 -> x + x\n");
              }
              else
              {
                  char buf[50];
                  sprintf(buf,"%s * %s",$1,$3);
                  $$ = strdup(buf);
              }
          }

        | expr '/' expr
          {
              if(isdigit($1[0]) && isdigit($3[0]))
              {
                  char buf[20];
                  sprintf(buf,"%d",atoi($1)/atoi($3));
                  $$ = strdup(buf);
                  printf("// Constant Folding: %s / %s -> %s\n",$1,$3,$$);
              }
              else if(strcmp($3,"1")==0)
              {
                  $$ = $1;
                  printf("// Algebraic Simplification: x / 1 -> x\n");
              }
              else
              {
                  char buf[50];
                  sprintf(buf,"%s / %s",$1,$3);
                  $$ = strdup(buf);
              }
          }

        ;

%%

int main()
{
    printf("Enter Three Address Code statements (Ctrl+D to stop):\n");
    yyparse();
    return 0;
}

int yyerror(const char *s)
{
    printf("Syntax Error: %s\n",s);
    return 0;
}
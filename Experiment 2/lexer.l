%{
#include <stdio.h>

FILE *yyin;
%}

KEYWORD    int|float|char|double|void|for|while|if|else|return|struct|switch|case|break|do

%%

"#include"                     { printf("Preprocessor Directive : %s\n", yytext); }
"<"[a-zA-Z.]+">"               { printf("Header File : %s\n", yytext); }

{KEYWORD}                      { printf("Keyword : %s\n", yytext); }

[a-zA-Z_][a-zA-Z0-9_]*         { printf("Identifier : %s\n", yytext); }

[0-9]+                         { printf("Number : %s\n", yytext); }

"=="|"<="|">="                { printf("Operator : %s\n", yytext); }

"+"|"-"|"*"|"/"|"="|"<"|">"   { printf("Operator : %s\n", yytext); }

[(){};,]                       { printf("Delimiter : %s\n", yytext); }

[ \t\n]                        { }

.                              { }

%%

int yywrap()
{
    return 1;
}

int main(int argc, char *argv[])
{
    if(argc < 2)
    {
        printf("Usage: %s <input file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");

    if(!yyin)
    {
        printf("Cannot open file %s\n", argv[1]);
        return 1;
    }

    yylex();

    printf("\nEnd of file\n");

    fclose(yyin);

    return 0;
}
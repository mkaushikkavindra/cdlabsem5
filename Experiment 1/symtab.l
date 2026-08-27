%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

struct symtab {
    char name[30];
    int type;
} symtab[100];

int sc = 0;
FILE *yyin;

int lookup(char *s)
{
    int i;
    for(i = 0; i < sc; i++)
        if(strcmp(symtab[i].name, s) == 0)
            return i;
    return -1;
}

void insert(char *s)
{
    if(lookup(s) == -1)
    {
        strcpy(symtab[sc].name, s);
        symtab[sc].type = 1;
        sc++;
    }
}
%}

DIGIT   [0-9]
ID      [a-zA-Z_][a-zA-Z0-9_]*

%%

"/*"([^*]|\*+[^*/])*\*+"/"     { printf("Comment : %s\n", yytext); }
"//".*                         { printf("Comment : %s\n", yytext); }

{ID}                           {
                                  insert(yytext);
                                  printf("Identifier : %s\n", yytext);
                               }

{DIGIT}+                       {
                                  printf("Constant : %s\n", yytext);
                               }

"+"|"-"|"*"|"/"|"="|"<"|">"    {
                                  printf("Operator : %s\n", yytext);
                               }

[ \t\n]                        { }

.                              { }

%%

int yywrap()
{
    return 1;
}

int main(int argc,char *argv[])
{
    if(argc<2)
    {
        printf("Usage: %s <input file>\n",argv[0]);
        return 1;
    }

    yyin=fopen(argv[1],"r");

    if(!yyin)
    {
        printf("Cannot open file %s\n",argv[1]);
        return 1;
    }

    yylex();

    printf("\nSYMBOL TABLE\n");
    printf("S.No\tName\n");

    int i;
    for(i=0;i<sc;i++)
        printf("%d\t%s\n",i+1,symtab[i].name);

    fclose(yyin);
    return 0;
}
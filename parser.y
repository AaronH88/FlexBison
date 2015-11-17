%{
#include<stdio.h>

int yylex();
%}
%token NOUN

%%
sentence: NOUN {
  printf("is a valid sentence!\n");}
%%

int main()
{
  yyparse();
  return(0);
}
int yyerror(char *s)
{
  fprintf(stderr, "%s\n", s);
}

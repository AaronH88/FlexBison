%{
#include<stdio.h>

int yylex();
%}
%token NOUN

%%
sentence: NOUN {
  printf("%s is a valid sentence!\n", $1);}
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

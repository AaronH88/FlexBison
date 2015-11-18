%{
#include <stdio.h>
#include <string.h>


int yyerror(char *s)
{
  fprintf(stderr, "%s\n", s);
}

int yywrap (void)
{
  return 1;
}

int main()
{
  yyparse();
  return(0);
}

%}
%token ADD TO NUM INT

%%

statements:
     | statements statement
     ;

statement:
     two_add
     ;

two_add:
        ADD NUM TO NUM
	{
	  printf("Adding numbers\n");
	}
        ;
%%

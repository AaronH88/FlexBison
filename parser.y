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
%token FSTOP COMMA TBEGIN TMOVE TREAD TPRINT TEND TADD TTO NUM INT VARNAME 

%%

statements:
     | statements statement
     ;

statement:
     two_add
     |
     declare_var
     ;

two_add:
        TADD NUM TTO NUM FSTOP
	{
	  printf("Adding numbers %d to %d, Result is: %d\n", $2, $4, $2 + $4);
	}
        ;

declare_var:
           INT VARNAME FSTOP
	   {
	     printf("Var: %s of size: %d\n" , $2, $1);
	   }
           ;

%%

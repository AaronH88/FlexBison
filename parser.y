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
%token ADD TO NUM INT VARNAME FSTOP

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
        ADD NUM TO NUM FSTOP
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

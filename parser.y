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
%token FSTOP COMMA TBEGIN TMOVE TREAD TPRINT TEND TADD TTO NUM INT VARNAME QUOTE 

%%
program: /* empty */
        |
        TBEGIN FSTOP smts TEND FSTOP
	;

smts: /* empty */ 
     |
     smts smt
     ;

smt: keytoken statement FSTOP
     ;

keytoken: INT | TREAD | TMOVE | TADD | TPRINT
        {
	  printf("keytoken called\n");
	}
        ;

statement: definites deff
     ;

definites:  /* empty */
         | definites deff separator
	 ;

separator: TTO | COMMA
{ printf("separator called\n");}
;

deff: NUM | VARNAME | QUOTE
    { printf("deff called\n");}
;


%%

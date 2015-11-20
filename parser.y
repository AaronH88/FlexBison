%{
#include <stdio.h>
#include <string.h>
typedef int bool;
#define true 1
#define false 0

int yyerror(char *s)
{
  fprintf(stderr, "%s\n", s);
}

int yywrap (void)
{
  return 1;
}

bool isVar(char* name);

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

smt: decloration FSTOP
    |
    add_move FSTOP
    |
    print_read FSTOP
    ;

decloration:
       INT VARNAME
       {


       }
       ;

add_move:
       TADD deff TTO deff
       {

       }
       |
       TMOVE deff TTO deff
       {

       }
       ;

print_read: /* not sure yet*/
       TPRINT
       {
	 printf("Print found\n");
       }
       |
       TREAD
       {
	 printf("Read found\n");
       }
       ;

deff:
     NUM
     {
       $$=$1;
     }
     |
     VARNAME
     {
       /* make struct */
     }
     ;

%%

bool isVar(char* name)
{
  return true;
}

int main()
{
  yyparse();
  return(0);
}

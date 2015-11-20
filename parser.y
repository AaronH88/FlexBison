%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
typedef int bool;
#define true 1
#define false 0
#define maxVars 50
/* Maybe new struct for quotes */
struct var
{
  char* name;

  int size;
  int value;
};

union myType{
  char * aString;
  int aInt;
};

int yyerror(char *s)
{
  fprintf(stderr, "%s\n", s);
}

int yywrap (void)
{
  return 1;
}

int isVar(char* name, int numOfVars);
bool createVars(char* n, int s);
 
 
%}
%token FSTOP COMMA TBEGIN TMOVE TREAD TPRINT TEND TADD TTO NUM INT VARNAME QUOTE 

%union
{
  int number;
  char* name;
  union myType* myT1;
}

%type<number> NUM
%type<name> VARNAME
%type<int> INT
%type<myT1> deff

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
	 if(createVars(*$2, $1))
	   {
	     printf("Varname: %s of size %d created\n", $2, $1);
	   }

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
       $$=$1;
     }
     ;

%%


struct var variables[maxVars];

/* this method will return pos of var or -1 if var cant be found*/
int isVar(char* name, int numOfVars)
{
  int pos = -1;
  for (int i = 0; i < numOfVars; i++)
  {
    if(!strcmp(variables[i].name, name))
      return i;

  }
  
  return pos;
}

bool createVars(char* n, int s)
{
  int length = sizeof(variables) / sizeof(variables[0]);
  /* first check to see if var has been declared already*/

  int pos = isVar(n, length);
  if(pos == -1){ /*var not declared already, store it now in finaly pos */
    struct var newVar;
    newVar.name = n;
    newVar.size = s;
    variables[length] = newVar;

  } else{
    /*var has been declared already, syntax error*/
    printf("syntax error: %s declared already\n",n);
    exit(0);
    return false;
  }
    
  return true;
}

int main()
{
  yyparse();
  return(0);
}

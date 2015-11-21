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

 void printNamesOfVars();
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
%type<number> INT
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
	 printf("Before calling create Vars\n");
	 if(createVars($2,$1))
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
int countOfVars = 0;

/* this is an error checking method, used to print out all current vars*/
void printNamesOfVars()
{
  for (int i = 0; i < maxVars; i++)
    {
      printf("Var name at pos %d is %s\n", i, variables[i].name);

    }

}

/* this method will return pos of var or -1 if var cant be found*/
int isVar(char* name, int numOfVars)
{
  int pos = -1;
  //printNamesOfVars();
  for (int i = 0; i < numOfVars; i++)
  {
    if(numOfVars == 0){
      return 0;
    }else if(!strcmp(variables[i].name, name)){
      return i;
    }
  }
  
  return pos;
}

bool createVars(char* n, int s)
{
  int length = sizeof(variables) / sizeof(variables[0]);
  /* first check to see if var has been declared already*/
  int pos = isVar(n, length);
  //printf("after isVar is called, pos is %d\n", pos);
  if(pos == -1){ /*var not declared already, store it now in finaly pos */
    struct var newVar;
    newVar.name = n;
    newVar.size = s;
    variables[countOfVars] = newVar;
    //printf("After setting the var to the array, Name: %s , Size: %d\n", variables[countOfVars].name, variables[countOfVars].size);
    countOfVars++;
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

  for (int i = 0; i < maxVars; i++)
  {
    struct var aVar;
    aVar.name = "";
    aVar.size = 0;
    aVar.value = 0;
    variables[i] = aVar;

  }
  yyparse();
  return(0);
}

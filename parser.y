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
int isVar(char* name);
bool createVars(char* n, int s);
void fillInVar(struct var* theVar);
 
 
%}
%token FSTOP COMMA TBEGIN TMOVE TREAD TPRINT TEND TADD TTO NUM INT VARNAME QUOTE 

%union
{
  int number;
  char* name;
  union myType* myT1;
  struct var* aVar;
}

%type<number> NUM
%type<name> VARNAME
%type<number> INT
%type<aVar> deff

%%
program: /* empty */
        |
        TBEGIN FSTOP smts TEND FSTOP
        {
	  printf("Program complete, exiting\n");
	  exit(0);
	}
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
	 //printf("Before calling create Vars\n");
	 if(createVars($2,$1))
	   {
	     printf("Varname: %s of size %d created\n", $2, $1);
	   }

       }
       ;

add_move:
       TADD deff TTO deff
       {
	 printf("in add_move\n");
	 struct var* var1;
	 struct var* var2;
	 var1= $2;
	 var2= $4;
	 /*check to see is deff is an int or var */
	 printf("Before ifs\n");
	 if(var1->value == NULL)
	 {
	   fillInVar(var1);
	 }
	 printf("After if 1\n"); 
	 if(var2->value == NULL)
	 {
	   fillInVar(var2);
	 }
	 printf("Adding %d to %d, Result is: %d\n", var1->value , var2->value, var1->value + var2->value);
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
       //printf("Making Numbers\n");
       struct var theVar;
       //printf("Made var\n");
       theVar.name = "";
       //printf("Set var name\n");
       theVar.size = 0;
       theVar.value = $1;
       //printf("Var made, returning var\n");
       $$=&theVar;
     }
     |
     VARNAME
     {
       printf("Got varname, making var\n");
       /* make struct */
       struct var theVar;
       theVar.name = $1;
       theVar.size = 0;
       theVar.value = NULL;
       printf("Varname made, returning var\n");
       $$=&theVar;
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
int isVar(char* name)
{
  int pos = -1;
  //printNamesOfVars();
  for (int i = 0; i < maxVars; i++)
  {
    if(!strcmp(variables[i].name, name)){
      return i;
    }
  }
  
  return pos;
}

bool createVars(char* n, int s)
{
  int length = sizeof(variables) / sizeof(variables[0]);
  /* first check to see if var has been declared already*/
  int pos = isVar(n);
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
/*method that will fill in a var variable stored already*/
void fillInVar(struct var* theVar)
{
  /* first check to see if the var exists, and if so get its pos*/
  int pos = isVar(theVar->name);
  if(pos == -1)
  {

  }
  
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

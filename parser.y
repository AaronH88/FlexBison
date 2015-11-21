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

int getNumSs(int num);
void printNamesOfVars();
int isVar(char* name);
bool createVars(char* n, int s);
void numTOVar(int num, char* theVar);
void varTOVar(char* var1, char* var2); 
 
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
       TADD NUM TTO VARNAME
       {
	 printf("in add_move\n");
	 
	 char* var2;
	 int var1= $2;
	 printf("About to set var2\n");
	 var2= $4;
	 numTOVar(var1,var2);
       }
       |
       TADD VARNAME TTO VARNAME
       {
	 char* var1;
	 char* var2;
	 var1 = $2;
	 var2 = $4;
	 varTOVar(var1, var2);

       }
       |
       TMOVE NUM TTO VARNAME
       {

       }
       |
       TMOVE VARNAME TTO VARNAME
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
       printf("Varname made %s, returning var\n", theVar.name);
       $$=&theVar;
     }
     ;

%%


struct var variables[maxVars];
int countOfVars = 0;

/*this method finds out how many s's are needed for a number*/
int getNumSs(int num)
{
  int noOfSs = 0;
  while (num > 0)
  {
    noOfSs++;
    num = num / 10;
  }
  
}

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
void numTOVar(int num, char* theVar)
{
  /* first check to see if the var exists, and if so get its pos*/
  printf("in num to Var\n");
  int pos = isVar(theVar);
  if(pos != -1)
  {
    printf("found var: %s\n", theVar);
    struct var aVar;
    aVar.name = theVar;
    aVar.size = variables[pos].size;
    aVar.value = variables[pos].value;
    printf("Var %s filled in with size %d and value %d\n", aVar.name, aVar.size, aVar.value);
    int newValue = num + aVar.value;
    printf("Var size: %d new varable size: %d\n", aVar.size,getNumSs(newValue));
    if(aVar.size >= getNumSs(newValue)){
      aVar.value = newValue;
      variables[pos] = aVar;
    }else {
      printf("Runtime error: The value %d is too big for var %s\n", newValue , aVar.name);
      exit(0);
    }
  }else {
    printf("sintax error: Var %s not found\n");
    exit(0);
  }
}

void varTOVar(char* var1, char* var2)
{
  int pos1 = isVar(var1);
  if(pos1 == -1){
    printf("syntax error: Var %s dosent exist\n", *var1);
    exit(0);
  }
  int pos2 = isVar(var2);
  if(pos2 == -1){
   printf("syntax error: Var %s dosent exist\n", *var2);
    exit(0);
  }
  struct var newVar;
  newVar.name = variables[pos2].name;
  newVar.size = variables[pos2].size;
  newVar.value = variables[pos1].value + variables[pos2].value;
  if(newVar.size >= getNumSs(newVar.value)){
    variables[pos2] = newVar;
    printf("The new value of %s is %d\n", newVar.name, newVar.value);
  }else {
      printf("Runtime error: The value %d is too big for var %s\n", newVar.value , newVar.name);
      exit(0);

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

%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
typedef int bool;
#define true 1
#define false 0
#define maxVars 50

 extern FILE *yyin;
 
/* Maybe new struct for quotes */
int yylex(void);
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
void moveNumTVar(int num, char* var);
void moveVarTVar(char* var1, char* var2);
void readInVars(char* var1);
void printOutVars(char *var1);

 
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
%type<name> QUOTE

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
	 int num = $2;
	 char* var = $4;
	 printf("Moving num to var\n");
	 moveNumTVar(num, var);
       }
       |
       TMOVE VARNAME TTO VARNAME
       {
	 char* var1;
	 char* var2;
	 var1 = $2;
	 var2 = $4;
	 printf("Moving var to var\n");
	 moveVarTVar(var1, var2);

       }
       ;

print_read: /* not sure yet*/
       TPRINT print_vars
       {
	 printf("\n");
       }
       |
       TREAD read_vars
       {
	 printf("Read found\n");
	 
       }
       ;

read_vars: VARNAME
    {
      char* var1 = $1;
      readInVars(var1);
    }
    |
    read_vars COMMA VARNAME
    {
      char* var1 = $3;
      readInVars(var1);

    }
    ;

print_vars: VARNAME
           {
	     char* var1 = $1;
	     printOutVars(var1);
	   }
           |
	   QUOTE
	   {
	     char* str = $1;
	     printf(" %s", str);
	   }
           |
	   print_vars COMMA VARNAME
	   {
	     printf(" ,");
     	     char* var1 = $3;
	     printOutVars(var1);

	   }
           |
	   print_vars COMMA QUOTE
	   {
	     printf(" ,");
	     char* str = $3;
	     printf(" %s", str);
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
    printf("syntax error: Var %s dosent exist\n", var1);
    exit(0);
  }
  int pos2 = isVar(var2);
  if(pos2 == -1){
   printf("syntax error: Var %s dosent exist\n", var2);
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

void moveNumTVar(int num, char* var)
{
  int pos = isVar(var);
  if(pos == -1){
    printf("syntax error: Var %s dosent exist\n", var);
    exit(0);
  }
  struct var newVar;
  newVar.name = variables[pos].name;
  newVar.size = variables[pos].size;
  newVar.value = num;
  if(newVar.size >= getNumSs(newVar.value)){
    variables[pos] = newVar;
    printf("The new value of %s is %d\n", newVar.name, newVar.value);
  }else {
      printf("Runtime error: The value %d is too big for var %s\n", newVar.value , newVar.name);
      exit(0);
  }
}

void moveVarTVar(char* var1, char* var2)
{
  int pos = isVar(var2);
  if(pos == -1){
    printf("syntax error: Var %s dosent exist\n", *var2);
    exit(0);
  }
  int pos1 = isVar(var1);
  if(pos1 == -1){
    printf("syntax error: Var %s dosent exist\n", *var1);
    exit(0);
  }
  struct var newVar;
  newVar.name = variables[pos].name;
  newVar.size = variables[pos].size;
  newVar.value = variables[pos1].value;
  if(newVar.size >= getNumSs(newVar.value)){
    variables[pos] = newVar;
    printf("The new value of %s is %d\n", newVar.name, newVar.value);
  }else {
      printf("Runtime error: The value %d is too big for var %s\n", newVar.value , newVar.name);
      exit(0);
  }
}

void readInVars(char* var1)
{
  int pos = isVar(var1);
  if(pos == -1){
    printf("syntax error: Var %s dosent exist\n", var1);
    exit(0);
  }
  int newVar = 0;
  printf("Please enter the int you wish to be in %s\n", var1);
  scanf("%d", &newVar);

  if(variables[pos].size >= getNumSs(newVar)){
    variables[pos].value = newVar;
    printf("The new value of %s is %d\n", var1, newVar);
  }else {
    printf("Runtime error: The value %d is too big for var %s\n", newVar , var1);
    exit(0);
  }


}


void printOutVars(char *var1)
{
  int pos = isVar(var1);
  if(pos == -1){
    printf("syntax error: Var %s dosent exist\n", var1);
    exit(0);
  }

  printf(" (Printing %s)%d",variables[pos].name,variables[pos].value);

}

int main(int argc, char *argv[])
{
  if(argc > 0)
    {
      yyin = fopen(argv[1],"r");
    }

  for (int i = 0; i < maxVars; i++)
  {
    struct var aVar;
    aVar.name = "";
    aVar.size = 0;
    aVar.value = 0;
    variables[i] = aVar;

  }
  yyparse();

  if(argc > 0)
    {
      fclose(yyin);
    }
  return(0);
}

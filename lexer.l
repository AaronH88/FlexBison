

%%

"hello world"	{ printf("hello world!"); }
"."             { printf(" Full Stop found!"); }
","             { printf(" comma found! "); }
"BEGIN"         { printf("Begin Found!"); }
[S]+            { printf("Decloration found!"); }
"MOVE"          { printf("Movement found!"); }
"TO"            { printf("To found!"); }
"ADD"           { printf("Addition found!"); }
"READ"          { printf("Read Found!"); }
"PRINT"         { printf("Print Found!"); }
"END"           { printf("End found!"); }
[\_\-]+[a-zA-Z]+[a-zA-Z0-9\-\_]*    {printf ("Invalid variable name");}
[a-zA-Z]+[a-zA-Z0-9\-\_]*       { printf(" Vairable name found! "); }
['^"'][a-zA-Z0-9\t \?]*['"$']  {printf("%s", yytext); }

[0-9]+          { printf(" Int number found! "); }

%%


main(){
	yylex();
}

int yywrap(){return 1;}

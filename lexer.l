%{

#include "parser.tab.h"

extern YYSTYPE yylval;
%}

%%

"."      return FSTOP;
ADD      return ADD;
TO       return TO;
[0-9]+   yylval=atoi(yytext); return NUM;
[S]+     yylval=yyleng; return INT;
[a-zA-Z]+[a-zA-Z0-9\-\_]*    yylval=strdup(yytext);return VARNAME;
[ \t]+   /* ignore space*/;
\n       /* ignore new line*/;

%%

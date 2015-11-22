%{

#include "parser.tab.h"
#define YYSTYPE char *


%}

%%

"."      return FSTOP;
","      return COMMA;
(?i:BEGIN)    return TBEGIN;
(?i:MOVE)     return TMOVE;
(?i:READ)     return TREAD;
(?i:PRINT)    return TPRINT;
(?i:END)      return TEND;
(?i:ADD)      return TADD;
(?i:TO)       return TTO;
[0-9]+   yylval.number=atoi(yytext); return NUM;
[sS]+     yylval.number=yyleng; return INT;
[a-zA-Z]+[a-zA-Z0-9\-\_]*    yylval.name=strdup(yytext);return VARNAME;
['^"'][a-zA-Z0-9\t \? \+ \=]*['"$']  yylval.name=strdup(yytext); return QUOTE;

[ \t]+   /* ignore space*/;
\n       /* ignore new line*/;

%%

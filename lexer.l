%{

#include "parser.tab.h"
#define YYSTYPE char *


%}

%%

"."      return FSTOP;
","      return COMMA;
BEGIN    return TBEGIN;
MOVE     return TMOVE;
READ     return TREAD;
PRINT    return TPRINT;
END      return TEND;
ADD      return TADD;
TO       return TTO;
[0-9]+   yylval=atoi(yytext); return NUM;
[S]+     yylval=yyleng; return INT;
[a-zA-Z]+[a-zA-Z0-9\-\_]*    yylval=strdup(yytext);return VARNAME;
[ \t]+   /* ignore space*/;
\n       /* ignore new line*/;

%%

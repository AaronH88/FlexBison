%{

#include "parser.tab.h"

extern YYSTYPE yylval;
%}

%%

ADD      return ADD;
TO       return TO;
[0-9]+   return NUM;
[S]+     return INT;
[ \t]+   /* ignore space*/;
\n       /* ignore new line*/;

%%

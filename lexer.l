%{

#include "parser.tab.h"
%}

%%

"cat"    return(NOUN);

%%

int yywrap (void)
{
  return 1;
}

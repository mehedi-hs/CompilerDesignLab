%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "simpl.tab.h"

%}
/* Rules Section */
%%
[0-9]+ { yylval.num=atoi(yytext); return NUMBER; }
[0-9]*\.[0-9]+ { yylval.frac=atof(yytext); return FRACTION; }
[a-zA-Z]+ {
    yylval.text = strdup(yytext);  // **REPLACE: yytext -> strdup(yytext)**
    return NAME;
}

"+" { return PLUS; }
"-" { return MINUS; }
"*" { return MULTIPLY;}
"/" { return DIVISION;}
"(" {return LEFTPAREN;}
")" {return RIGHTPAREN;}

\n { return EOL; }
[ \t\r]+ { /* Ignore spaces */ }  // **REPLACE: empty action**
. { printf("Unknown character: %s\n", yytext);}

%%

int yywrap(void) { return 1; }
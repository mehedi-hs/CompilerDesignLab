/*Definition Section */
%{
#include <stdio.h>
int keywords=0;
int identifiers=0;
int ends_with_digit=0;
int starts_with_digit=0;
%}


/*Rules Section */
%%
(int|printf|float) { 
    keywords++; 
    printf("%s is a keyword \n", yytext);    
}

[a-zA-Z_][a-zA-Z_0-9]* {
    identifiers++; 
    printf("%s is a identifier \n", yytext);
}

[a-zA-Z0-9_]*[0-9] {
    ends_with_digit++; 
    printf("%s ends with digit \n", yytext);
}

[0-9][a-zA-Z0-9_]* {
    starts_with_digit++; 
    printf("%s starts with digit \n", yytext);
}

[ \t\n]+ {}

. {}

%%

/* User code */

int main() {
    yyin=fopen("input.c", "r");
    if(yyin == NULL) {
        printf("Error: Cannot open input.c file\n");
        return 1;
    }
    yylex();
    fclose(yyin);
    printf("\n--- Summary ---\n");
    printf("Total number of keywords: %d \n", keywords);
    printf("Total number of identifiers: %d \n", identifiers);
    printf("Total ends with digit: %d \n", ends_with_digit);
    printf("Total starts with digit: %d \n", starts_with_digit);
}

int yywrap() {
    return 1;
}
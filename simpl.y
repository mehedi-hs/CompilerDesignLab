%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror(const char *s);
extern FILE *yyin;
%}

%union {
    int num;
    float frac;
    char* text;
}

/* Token */
%token EOL
%token <num> NUMBER
%token <frac> FRACTION
%token <text> NAME
%token PLUS
%type <num> exp
%type <frac> exp2
%token MINUS
%token MULTIPLY
%token DIVISION  // **ADD: Missing token declaration**
%left PLUS MINUS
%left MULTIPLY DIVISION
%token LEFTPAREN
%token RIGHTPAREN
%type <num> fact
%type <frac> fact2
%type <text> string

%%

input:
    /* empty */  // **REPLACE: nothing -> /* empty */**
    | input line
;

line:
    exp EOL { printf("%d \n", $1); }
    | exp { printf("%d \n", $1); }
    | exp2 EOL { printf("%f \n", $1); }
    | exp2 { printf("%f \n", $1); }
    | string EOL {  // **REPLACE: Remove free from here**
        printf("%s \n", $1);
        free($1);
      }
    | string { 
        printf("%s \n", $1);
        free($1);
      }
    | EOL { }
;

exp:
    exp PLUS exp { $$ = $1 + $3; }
    | exp MINUS exp { $$ = $1 - $3; }
    | exp MULTIPLY exp { $$ = $1 * $3; }
    | exp DIVISION exp { $$ = $1 / $3; }
    | fact  // **ADD: Missing default action**
    ;

exp2:
    exp2 PLUS exp2 { $$ = $1 + $3; }
    | exp2 MINUS exp2 { $$ = $1 - $3; }
    | exp2 MULTIPLY exp2 { $$ = $1 * $3; }
    | exp2 DIVISION exp2 { $$ = $1 / $3; }
    | fact2  // **ADD: Missing default action**
    ;

fact:
    NUMBER { $$ = $1; }
    | LEFTPAREN exp RIGHTPAREN { $$ = $2; }  // **ADD: Missing semicolon**
    ;

fact2:
    FRACTION { $$ = $1; }
    | LEFTPAREN exp2 RIGHTPAREN { $$ = $2; }  // **ADD: Missing semicolon**
    ;

string:
    NAME { $$ = $1; }
    | string PLUS NAME {  
        char *tmp = malloc(strlen($1) + strlen($3) + 2);  // **REPLACE: +1 -> +2**
        strcpy(tmp, $1);
        strcat(tmp, " ");  // **ADD: Space between words**
        strcat(tmp, $3);
        free($1);
        free($3);
        $$ = tmp;
      }
    ;

%%

int main(void) {
    yyin = fopen("input.txt", "r");
    if (yyin == NULL) {  // **ADD: Error checking**
        printf("Error: Cannot open input.txt\n");
        return 1;
    }
    int res = yyparse();
    fclose(yyin);
    return res;
}

int yyerror(const char *s) {
    printf("ERROR: %s \n", s);
    return 0;
}
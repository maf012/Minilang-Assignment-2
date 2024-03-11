%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "MyParser.tab.h"
int yylex();
%}

%union {int val; char* id;}
%token <val> NUMBER
%token <id> IDENTIFIER

%% 
expression: term extendedExpression
    ;

extendedExpression: '+' term extendedExpression { printf("+ "); }
    | '-' term extendedExpression { printf("- "); }
    | /* void */ { printf("\n"); }
    ;

term: factor optionalTerm
    ;

optionalTerm: '*' factor optionalTerm { printf("* "); }
    | /* void */ { }
    ;

factor: NUMBER { printf("Value= %d ", $1); }
    | IDENTIFIER { printf("Identifier = %s ", $1); free($1); }
    | '(' expression ')' { }
    ;
%%

int handleError(const char* msg) {
    fprintf(stderr, "Error: %s\n", msg);
    return 1;
}

int main() {
    yyparse();  // Trigger the parsing process
    return 0;
}

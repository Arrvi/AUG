%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sstream>

int yylex();
void yyerror( char* );
extern char* yytext;

const char * to_roman( int );
int result;

%}

%union {
  int       i;
}

%left '+' '-'
%left '*' '/' '%'
%left UNARY_MINUS UNARY_PLUS


%token <i> NUM

%type <i> num num_expr expr

%start expr

%%

expr    : num_expr { @1; result=$1;}
        ;
num     : NUM { $$=$1;}
        ;
num_expr    : num                            { $$=$1;}
            | '-' num_expr %prec UNARY_MINUS { $$=-$2;}
            | '+' num_expr %prec UNARY_PLUS  { $$=$2;}
            | num_expr '+' num_expr          { $$=$1+$3;}
            | num_expr '-' num_expr          { $$=$1-$3;}
            | num_expr '*' num_expr          { $$=$1*$3;}
            | num_expr '/' num_expr          { $$=$1/$3;}
            | num_expr '%' num_expr          { $$=$1%$3;}
            | '(' num_expr ')'               { $$=$2;}
            ;

%%

void yyerror( char* s )
{
  fprintf(stderr,"unexpected token: '%s'\n",yytext);
  exit(1);
}

const char * to_roman(int i) 
{
    std::ostringstream oss;
    while (i > 0) {
        if (i >= 1000) {
            oss << "M";
            i -= 1000;
        } else if ( i >= 900 ) {
            oss << "CM";
            i -= 900;
        } else if (i >= 500) {
            oss << "D";
            i -= 500;
        } else if (i >= 400) {
            oss << "CD";
            i -= 400;
        } else if (i >= 100) {
            oss << "C";
            i -= 100;
        } else if (i >= 90) {
            oss << "XC";
            i -= 90;
        } else if (i >= 50) {
            oss << "L";
            i -= 50;
        } else if (i >= 40) {
            oss << "XL";
            i -= 40;
        } else if (i >= 10) {
            oss << "X";
            i -= 10;
        } else if (i >= 9) {
            oss << "IX";
            i -= 9;
        } else if (i >= 5) {
            oss << "V";
            i -= 5;
        } else if (i >= 4) {
            oss << "IV";
            i -= 4;
        } else {
            oss << "I";
            i -= 1;
        }
    }
    return oss.str().c_str();
}

int main() {
   yyparse();
   printf("result = %s\n", to_roman(result));
   return 0;
}

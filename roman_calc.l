%{
#include "roman_calc_p.h"
	
int to_int();
int roman_to_int();
int get_roman_value(char digit);

%}

OP	          "+"|"-"|"*"|"/"|"%"
BRACKET	      "("|")"
DIGIT	      [0-9]
R_I           IV|I{1,3}
R_V           IX|V{R_I}?|{R_I}
R_X           XL{R_V}?|X{1,3}{R_V}?|{R_V}
R_L           XC{R_V}?|L{R_X}?|{R_X}
R_C           CD{R_L}?|C{1,3}{R_L}?|{R_L}
R_D           CM{R_L}?|D{R_C}?|{R_C}
ROMAN_NUMERAL M{1,3}{R_D}?|{R_D}
%%

{OP}		    return yytext[0];
{BRACKET}	    return yytext[0];
{DIGIT}+	    return to_int();
{ROMAN_NUMERAL} return roman_to_int();

%%

int to_int()
{
  int i=0;
  
  yylval.i=0;
  for(;i<strlen(yytext);i++)
    if(yytext[i]!='_') yylval.i=yylval.i*10+yytext[i]-'0';
  return NUM;
}

int roman_to_int()
{
	yylval.i=0;

	int last=0;
	int curr=0;

	for(int i=0;i<strlen(yytext);i++) {
		if(yytext[i]!='_') {
			curr = get_roman_value(yytext[i]);
			yylval.i += curr;
			if (last && last < curr) {
				yylval.i-=last*2;
			}
			last = curr;
		}
	}
	return NUM;
}

int get_roman_value(char digit) {
	switch (digit) 
	{
		case 'I': return 1;
		case 'V': return 5;
		case 'X': return 10;
		case 'L': return 50;
		case 'C': return 100;
		case 'D': return 500;
		case 'M': return 1000;
		default: return 0;
	}
}

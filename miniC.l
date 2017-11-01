%{
// Código C
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
// Deficnición de códigos de tokens
#include "miniC.tab.h"
#include "translator.h"
void comprobar_longitud();
int comentario_retorno();
%}
digito [0-9]
letra [a-zA-Z]
entero [0-9]+



%x comentario
%x string
%%



func	return FUNC;
var		return VAR;
let		return LET;
if		return IF;
else	return ELSE;
while	return WHILE;
print	return PRINT;
read	return READ;
do		return DO;
";"		return SEMICOLON;
"," 	return COMA;
"+"		return PLUS;
"-"		return MINUS;
"*"		return ASTERISC;
"/"		return SLASH;
"="		return EQUAL;
"("		return LEFTPAREN;
")"		return RIGHTPAREN;
"{"		return LCURLYBRACKET;
"}"		return RCURLYBRACKET;
"for" return FOR;
"&&"	return AND;
"||"	return OR;
"!="	return DIFFERENT;
">"		return GREATERTHAN;
"<"		return LESSERTHAN;
">="	return GTOREQ;	// greater or equal
"<="	return LSSROREQ;	// lesser or equal
"=="	return IGIG;			// equalequal
\"([^\n"]|\\\")*\" {

	yylval.str = strdup(yytext);
	return STRING;
}

{entero} {
	comprobar_longitud();
	return NUM;
}

"//".*		{}

({letra}|_)({letra}|_|{digito})*	{

			if (yyleng > 16){
					printf("Error: EL identificador es demasiado grande \n");
					yytext[16] = '\0';
			 }
			yylval.str = strdup(yytext);
			return ID;
}

[^a-zA-A0-9_/\- \n\t\r(){}*+/=,;"]+	{ printf("Carácter no válido: %s\n",yytext); }



"/*"		   	        BEGIN comentario;
<comentario>[^*]*		;
<comentario>[*]+[^/*]*		;
<comentario><<EOF>>		{return comentario_retorno();}
<comentario>[*]+[/]		BEGIN 0;


%%

void comprobar_longitud() {
 double l = atol(yytext);
 if (l > pow(2,31)) {
	printf("el numero %f es demasiado grande", l);
 }
 yylval.str = strdup(yytext);
}


int comentario_retorno(){
	return 0;
}

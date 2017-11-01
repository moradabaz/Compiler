#include "miniC.h"
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int yylex();
extern char *yytext;
extern int yyparse();
extern int yydebug;

int main(int argc, char **argv) {
	if (argc != 2) {
		printf("USO: %s fichero.c \n",argv[0]);
		exit(1);
	}

	FILE *fichero = fopen(argv[1],"r");
	if (fichero == NULL) {
		printf("No se puede abrir %s\n",argv[1]);
		exit(2);
	}
	yyin = fichero;
//        yydebug = 1;
        yyparse();
	fclose(fichero);
}

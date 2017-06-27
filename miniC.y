%{
#include<stdio.h>
#include<stdlib.h>
// Deficnición de códigos de tokens
#include <math.h>
#include "lista.h"
#include "traductor.h"

extern int yylineno;
extern int yylex();
int yyerror (const char *msg);
lista t;
int tipo;
%}

%union{
	char *str;
	struct listaCodigo * l;
}

%expect 1
%token <str> ID
%token <str> NUM
%token <str> CADENA
%token FUNC VAR LET IF ELSE WHILE PRINT READ PUNTOCOMA COMA SUMA MENOS IGUAL PARIZQUIERDO PARDERECHO LLAVEIZQUIERDA LLAVEDERECHA
%right IGUAL					// EXPLICA LA SEMANA QUE VIENE
%left SUMA MENOS
%left ASTERISCO CONTRABARRA
%left UMENOS

%type <l> expresion read_list print_item print_list statement statement_list asig
%%
program : { t = crearLista(); } FUNC ID PARIZQUIERDO PARDERECHO LLAVEIZQUIERDA declarations statement_list LLAVEDERECHA {
						imprimirVariables(t);
						imprimirlistaCodigo($8);
						liberarlistaCodigo($8);

					}
				| error PUNTOCOMA {printf("error en la asignacion en la linea %d\n", yylineno); }
				;
declarations 	: declarations VAR { tipo = 1; } identifier_list PUNTOCOMA { }
							| declarations LET { tipo = 2; } identifier_list PUNTOCOMA {  }
							| {}
							;
identifier_list : asig {
									//	if (consultarVariable(t, $1) > 0) printf("Existente\n");
									//	else insertarVariable(&t, $1, tipo);
									}
								| identifier_list COMA asig {
									//if (consultarVariable(t, $3) > 0) printf("%s Existente\n", $3);
									//  else insertarVariable(t, $3, tipo);
								}
								;
asig		: ID {
						if(consultarVariable(t, $1) > 0)	printf("ID %s ya existente\n", $1);
						else {
							insertarVariable(&t, $1, tipo);
						}
					}
				| ID IGUAL expresion {
							if(consultarVariable(t, $1) > 0) {
								//printf("Variable %s ya declarada\n", $1);
							} else {
								insertarVariable(&t, $1, tipo);
								$$ = nueva_listaCodigo();
								char* etiqueta = barra($1);
								Cuadrupla c1 = nueva_cuadrupla("sw ", $3->ultima->destino, etiqueta, NULL);
								enlazarlistaCodigos(&$$, $3);
								insertarCuadrupla(c1, &$$);
								eliminarRegistro($3);
							}
					}

statement_list	: statement_list statement {
										$$ = nueva_listaCodigo();
										enlazarlistaCodigos(&$$, $1);
										enlazarlistaCodigos(&$$, $2);
									}
								| {$$ = nueva_listaCodigo();}
								;
statement	: ID IGUAL expresion PUNTOCOMA {
									if(consultarVariable(t, $1) > 0) {
										//printf("Variable %s ya existente\n", $1);
									} else {
										insertarVariable(&t, $1, tipo);
										$$ = nueva_listaCodigo();
										char* etiqueta = barra($1);
										Cuadrupla c1 = nueva_cuadrupla("sw ", $3->ultima->destino, etiqueta, NULL);
										enlazarlistaCodigos(&$$, $3);
										insertarCuadrupla(c1, &$$);
										eliminarRegistro($3);
									}
						}
					| LLAVEIZQUIERDA statement_list LLAVEDERECHA {
						$$ = nueva_listaCodigo();
						enlazarlistaCodigos(&$$, $2);
					}
					| IF PARIZQUIERDO expresion PARDERECHO statement ELSE statement {
								Cuadrupla c1 = nueva_cuadrupla(crear_etiqueta(), NULL, NULL, NULL);
								Cuadrupla c2 = nueva_cuadrupla(crear_etiqueta(), NULL, NULL, NULL);
								Cuadrupla c3 = nueva_cuadrupla("beqz ", NULL, $3->primera->destino, c1->op);
								Cuadrupla c4 = nueva_cuadrupla("b ", c2->op, NULL, NULL);
								$$ = nueva_listaCodigo();							// creamos la lista de codigo
								enlazarlistaCodigos(&$$, $3);					// enlazamos con la sentencia beqz
								insertarCuadrupla(c3, &$$);						// insertamos la cuadrupla en $$
								enlazarlistaCodigos(&$$, $5);					// enlazamos  $$ con STATEMENT
								insertarCuadrupla(c4, &$$);						// insertamos el branch en $$
								insertarCuadrupla(c1, &$$);						// insertamos la cuadrupla 1 en $$
								enlazarlistaCodigos(&$$, $7);					// enlazamos
								insertarCuadrupla(c2, &$$);						// insertamos
								eliminarRegistro($3);									// eliminamos registro
						}


					| IF PARIZQUIERDO expresion PARDERECHO statement {
							char *etiqueta = crear_etiqueta();

							Cuadrupla c1 = nueva_cuadrupla(etiqueta, NULL, NULL, NULL);
							Cuadrupla c2 = nueva_cuadrupla("beqz ", NULL, $3->primera->destino, c1->op);
							$$ = nueva_listaCodigo();
							enlazarlistaCodigos(&$$, $3);						// expresion
							insertarCuadrupla(c2, &$$);							// BEQZ
							enlazarlistaCodigos(&$$, $5);						// statement
							insertarCuadrupla(c1, &$$);							// ETIQUETA
							eliminarRegistro($3);
					  }


					| WHILE PARIZQUIERDO expresion	PARDERECHO statement {

						Cuadrupla c1 = nueva_cuadrupla(crear_etiqueta(), NULL, NULL, NULL);
				 		Cuadrupla c2 = nueva_cuadrupla(crear_etiqueta(), NULL, NULL, NULL);
				 		Cuadrupla c3 = nueva_cuadrupla("beqz ",  NULL, $3->primera->destino, c2->op);
				 		Cuadrupla c4 = nueva_cuadrupla("b ", NULL, c1->op, NULL);
				 		$$ = nueva_listaCodigo();
				 		insertarCuadrupla(c1, &$$);				// ETIQUETA
				 		enlazarlistaCodigos(&$$, $3);						// expresion
				 		insertarCuadrupla(c3, &$$);				// BEQZ
				 		enlazarlistaCodigos(&$$, $5);						// statement
				 		insertarCuadrupla(c4, &$$);				// B
				 		insertarCuadrupla(c2, &$$);				// ETIQUETA
				 		eliminarRegistro($3);							//

						}

					| PRINT print_list PUNTOCOMA {
						$$ = nueva_listaCodigo();
						enlazarlistaCodigos(&$$, $2);
					}


					| READ read_list PUNTOCOMA {
						$$ = nueva_listaCodigo();
						enlazarlistaCodigos(&$$, $2);
						}
					;

print_list	: print_item {
							$$ = nueva_listaCodigo();
							enlazarlistaCodigos(&$$, $1);
						}
						| print_list COMA print_item {
							$$ = nueva_listaCodigo();
							enlazarlistaCodigos(&$$, $1);
							enlazarlistaCodigos(&$$, $3);
						}
						;

print_item	: expresion {
								$$ = nueva_listaCodigo();
								Cuadrupla c1 = nueva_cuadrupla("move ", "$a0 ", $1->primera->destino, NULL);
								Cuadrupla c2 = nueva_cuadrupla("li ", "$v0 ", "1", NULL);
								Cuadrupla c3 = nueva_cuadrupla("syscall", NULL, NULL, NULL);
								enlazarlistaCodigos(&$$, $1);
								insertarCuadrupla(c1, &$$);
								insertarCuadrupla(c2, &$$);
								insertarCuadrupla(c3, &$$);
								eliminarRegistro($1);

							}
						| CADENA {
							insertarVariable(&t, $1, 1);
							char *etiqueta = getLabel(t, $1);
							Cuadrupla c1 = nueva_cuadrupla("la ", "$a0 ", etiqueta, NULL);
							Cuadrupla c2 = nueva_cuadrupla("li ", "$v0 ", "4", NULL);
							Cuadrupla c3 = nueva_cuadrupla("syscall", NULL, NULL, NULL);
							$$ = nueva_listaCodigo();
							insertarCuadrupla(c1, &$$);		// la $a0, _expresion
							insertarCuadrupla(c2, &$$);		// li $v0, 4
							insertarCuadrupla(c3, &$$);		// syscall;
							}
						;

read_list	: ID	{
								if(consultarVariable(t, $1) == 0) {
									printf("variable no encontrada\n");
								} else {
									char* label = barra($1);
									Cuadrupla c1 = nueva_cuadrupla("li ", "$v0 ", "5", NULL);
									Cuadrupla c2 = nueva_cuadrupla("syscall", NULL, NULL, NULL);
									Cuadrupla c3 = nueva_cuadrupla("sw ", "$v0 ", label, NULL);
									$$ = nueva_listaCodigo();
									insertarCuadrupla(c1, &$$);
									insertarCuadrupla(c2, &$$);
									insertarCuadrupla(c3, &$$);
								}

						}
					| read_list COMA ID {
							if (consultarVariable(t, $3) == 0){
								printf("variable no encontrada\n");
							} else {
								$$ = nueva_listaCodigo();
								Cuadrupla c1 = nueva_cuadrupla("li ", "$v0 ", "5", NULL);
								Cuadrupla c2 = nueva_cuadrupla("syscall", NULL, NULL, NULL);
								Cuadrupla c3 = nueva_cuadrupla("sw ", "$v0 ", $3, NULL);
								enlazarlistaCodigos(&$$, $1);
								insertarCuadrupla(c1, &$$);
								insertarCuadrupla(c2, &$$);
								insertarCuadrupla(c3, &$$);
							}
						}
					;


expresion	: expresion SUMA expresion {
						char* reg = registro_actual();
						Cuadrupla c = nueva_cuadrupla("add ",reg,  $1->ultima->destino, $3->ultima->destino);
						$$ = nueva_listaCodigo();
						enlazarlistaCodigos(&$$, $1);
						enlazarlistaCodigos(&$$, $3);
						insertarCuadrupla(c, &$$);
						eliminarRegistro($1);
						eliminarRegistro($3);

					 }
					| expresion MENOS expresion {
							char* reg = registro_actual();
							Cuadrupla c = nueva_cuadrupla("sub ", reg,  $1->ultima->destino, $3->ultima->destino);
							$$ = nueva_listaCodigo();
							enlazarlistaCodigos(&$$, $1);
							enlazarlistaCodigos(&$$, $3);
							insertarCuadrupla(c, &$$);
							eliminarRegistro($1);
							eliminarRegistro($3);
						}

					| expresion ASTERISCO expresion {
							char* reg = registro_actual();
							Cuadrupla c = nueva_cuadrupla("mul ",reg , $1->ultima->destino, $3->ultima->destino);
							$$ = nueva_listaCodigo();
							enlazarlistaCodigos(&$$, $1);
							enlazarlistaCodigos(&$$, $3);

							insertarCuadrupla(c, &$$);
							eliminarRegistro($1);
							eliminarRegistro($3);
						}
					| expresion CONTRABARRA expresion {
						 char* reg = registro_actual();
						 Cuadrupla c = nueva_cuadrupla("div ", reg, $1->ultima->destino, $3->ultima->destino);
						 $$ = nueva_listaCodigo();
						 enlazarlistaCodigos(&$$, $1);
						 enlazarlistaCodigos(&$$, $3);

						 insertarCuadrupla(c, &$$);
						 eliminarRegistro($1);
						 eliminarRegistro($3);

						}
					| MENOS expresion %prec UMENOS {
						 char* reg = registro_actual();
						 Cuadrupla c = nueva_cuadrupla("neg ", reg, $2->ultima->destino, NULL);
						 enlazarlistaCodigos(&$$, $2);
						 insertarCuadrupla(c, &$$);
						}
					| PARIZQUIERDO expresion PARDERECHO {
								$$ = nueva_listaCodigo();
								enlazarlistaCodigos(&$$, $2);
								$$->primera->destino = $2->primera->destino;
								$$->ultima->destino = $2->ultima->destino;
						}
					| ID {
						if (consultarVariable(t, $1) == 0) {
											printf("ID %s no declarado\n",$1);
							} else {
									char *reg = registro_actual();
									$$ = nueva_listaCodigo();
									Cuadrupla c = nueva_cuadrupla("lw ", reg, barra($1), NULL);
									insertarCuadrupla(c, &$$);
							}
						}



					| NUM { $$ = nueva_listaCodigo();															// Creamos una nuevo codigo de ensamblador
									char * reg = registro_actual();												// Creamos un registro actual, el primero que este libre
									Cuadrupla c = nueva_cuadrupla("li ", reg, $1, NULL);		// Creamos una cuadrupla de la sentencia de carga inmediata
									insertarCuadrupla(c, &$$);															// Insertamos la cuadrupla en el codigo

						}
					;

%%

int yyerror(const char *msg) {
	fprintf(stderr, " %s en linea : %d\n", msg, yylineno);
	return 0;
}

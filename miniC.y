%{
#include<stdio.h>
#include<stdlib.h>
// Deficnición de códigos de tokens
#include <math.h>
#include "list.h"
#include "translator.h"

extern int yylineno;
extern int yylex();
int yyerror (const char *msg);
list t;
int type;
%}

%union{
	char *str;
	struct codeList * l;
}

%expect 2
%token <str> ID
%token <str> NUM
%token <str> STRING
%token OR AND DO FUNC VAR LET IF ELSE WHILE PRINT READ SEMICOLON COMA PLUS MINUS EQUAL LEFTPAREN RIGHTPAREN RCURLYBRACKET LCURLYBRACKET FOR
%right EQUAL					// EXPLICA LA SEMANA QUE VIENE
%left PLUS MINUS
%left ASTERISC SLASH
%left UMINUS
%nonassoc IGIG GREATERTHAN LESSERTHAN GTOREQ LSSROREQ DIFFERENT
%left OR AND

%type <l> expresion read_list print_item print_list statement statement_list asig declarations identifier_list boolean
%%
program : { t = createList(); } FUNC ID LEFTPAREN RIGHTPAREN LCURLYBRACKET declarations statement_list RCURLYBRACKET {
						printVariables(t);
						printCodeLists($7, $8);
						freeCodeList($8);

					}
				| error SEMICOLON {printf("error en la asignacion en la linea %d\n", yylineno); }
				;
declarations 	: declarations VAR { type = 1; } identifier_list SEMICOLON {
									$$ = new_CodeList();
									linkCodeList($$, $1);
									linkCodeList($$, $4);
								}
							| declarations LET { type = 2; } identifier_list SEMICOLON {
								$$ = new_CodeList();
								linkCodeList($$, $1);
								linkCodeList($$, $4); }
							| {$$ = new_CodeList();}
							;
identifier_list : asig {
									$$ = new_CodeList();
									linkCodeList($$, $1);
									//	if (checkVariable(t, $1) > 0) printf("Existente\n");
									//	else insertVariable(&t, $1, type);
									}
								| identifier_list COMA asig {
									$$ = new_CodeList();
									linkCodeList($$, $1);
									linkCodeList($$, $3);
									// if (checkVariable(t, $3) > 0) printf("%s Existente\n", $3);
								  // else insertVariable(t, $3, type);
								}
								;
asig		: ID {
						if(checkVariable(t, $1) > 0)	printf("ID %s ya existente\n", $1);
						else {

							insertVariable(&t, $1, type);
							$$ = new_CodeList();

						}
					}
				| ID EQUAL expresion {
							if(checkVariable(t, $1) == 0) {
								insertVariable(&t, $1, type);
								$$ = new_CodeList();
								char* label = underScore($1);
								Instruction c1 = new_instruction("sw ", $3->last->result, label, NULL);
								linkCodeList($$, $3);
								insertInstruction(c1, $$);
								delete_register($3);
							} else {
								printf("variable ya existente");
							}
					}

statement_list	: statement_list statement {
										$$ = new_CodeList();
										linkCodeList($$, $1);
										linkCodeList($$, $2);
									}
								| {$$ = new_CodeList();}
								;

statement	: 							ID EQUAL expresion SEMICOLON {
														int n = checkVariable(t, $1);

														  if(checkVariable(t, $1) > 0) {
																	if(n == 1){
																		insertVariable(&t, $1, type);
																		$$ = new_CodeList();
																		char* label = underScore($1);
																		Instruction c1 = new_instruction("sw ", $3->last->result, label, NULL);
																		linkCodeList($$, $3);
																		insertInstruction(c1, $$);
																		delete_register($3);
																	} else {
																			printf("Las constantes no pueden ser modificadas\n");
																		}
															}
														}
														| IF LEFTPAREN boolean RIGHTPAREN statement ELSE statement{
															Instruction c1 = new_instruction(create_label(), NULL, NULL, NULL);
															Instruction c2 = new_instruction(create_label(), NULL, NULL, NULL);
															Instruction c3 = new_instruction("beqz ", NULL, $3->first->result, c1->op);
															Instruction c4 = new_instruction("b ", NULL, c2->op, NULL);
															$$ = new_CodeList();							// creamos la lista de codigo
															linkCodeList($$, $3);					// enlazamos con la expresion
															insertInstruction(c3, $$);						// insertamos la Instruction de beqz en $$
															linkCodeList($$, $5);					// enlazamos  $$ con el primer STATEMENT
															insertInstruction(c4, $$);						// insertamos el branch en $$
															insertInstruction(c1, $$);						// insertamos la Instruction 1 en $$
															linkCodeList($$, $7);					// enlazamos
															insertInstruction(c2, $$);						// insertamos
															delete_register($3);

														}
														| IF LEFTPAREN boolean RIGHTPAREN statement{
															$$ = new_CodeList();
															char *label = create_label();
															Instruction c1 = new_instruction(label, NULL, NULL, NULL);
															Instruction c2 = new_instruction("beqz ", NULL, $3->first->result, c1->op);
															linkCodeList($$, $3);						// expresion
															insertInstruction(c2, $$);							// BEQZ
															linkCodeList($$, $5);						// statement
															insertInstruction(c1, $$);							// label
															delete_register($3);
														}
														| LCURLYBRACKET statement_list RCURLYBRACKET {
															$$ = new_CodeList();
															linkCodeList($$, $2);
														}

														| WHILE LEFTPAREN boolean	RIGHTPAREN statement {
																Instruction c1 = new_instruction(create_label(), NULL, NULL, NULL);
														 		Instruction c2 = new_instruction(create_label(), NULL, NULL, NULL);
														 		Instruction c3 = new_instruction("beqz ",  NULL, $3->first->result, c2->op);
														 		Instruction c4 = new_instruction("b ", NULL, c1->op, NULL);

														 		$$ = new_CodeList();
														 		insertInstruction(c1, $$);							// label
														 		linkCodeList($$, $3);						// expresion
														 		insertInstruction(c3, $$);							// BEQZ
														 		linkCodeList($$, $5);						// statement
														 		insertInstruction(c4, $$);							// B
														 		insertInstruction(c2, $$);							// label
														 		delete_register($3);										//
															}
														 | DO statement WHILE boolean SEMICOLON {
															 Instruction c1 = new_instruction(create_label(),NULL,NULL,NULL);
															 Instruction c2 = new_instruction("bnez", $4->first->result, c1->op, NULL);
															 $$ = new_CodeList();
															 insertInstruction(c1, $$);			   //label
															 linkCodeList($$, $2);						//statement
															 linkCodeList($$, $4);						//expresion
															 insertInstruction(c2, $$);			    //bnez
															 delete_register($4);							//eliminar exp
														 }



					| FOR LEFTPAREN ID EQUAL expresion SEMICOLON boolean SEMICOLON  ID EQUAL expresion RIGHTPAREN LCURLYBRACKET statement_list RCURLYBRACKET {

										Instruction Label1 = new_instruction(create_label(), NULL, NULL, NULL);
										Instruction Label2 = new_instruction(create_label(), NULL, NULL, NULL);

										Instruction sw1 = new_instruction("sw", $5->last->result, underScore($3), NULL);
										Instruction sb = new_instruction("sb",$11->last->result, underScore($9), NULL);
										Instruction beq = new_instruction("bnez",NULL,  $7->first->result, Label2->op);
										Instruction sw2 = new_instruction("sw", $11->last->result, underScore($9), NULL);
										Instruction b = new_instruction("b",NULL , NULL, Label1->op);

										$$ = new_CodeList();

										linkCodeList($$,$5);
										insertInstruction(sw1, $$);
										linkCodeList($$,$7);
										insertInstruction(Label1, $$);
										insertInstruction(sb, $$);
										insertInstruction(beq, $$);
										linkCodeList($$, $14);
										linkCodeList($$, $11);
										insertInstruction(sw2, $$);
										insertInstruction(b, $$);
										insertInstruction(Label2, $$);
										delete_register($5);
										delete_register($7);
										delete_register($11);

						}

						| PRINT print_list SEMICOLON {
							$$ = new_CodeList();
							linkCodeList($$, $2);
						}


					| READ read_list SEMICOLON {
						$$ = new_CodeList();
						linkCodeList($$, $2);
						}



					;

print_list	: print_item {
							$$ = new_CodeList();
							linkCodeList($$, $1);
						}
						| print_list COMA print_item {
							$$ = new_CodeList();
							linkCodeList($$, $1);
							linkCodeList($$, $3);
						}
						;

print_item	: expresion {
								$$ = new_CodeList();
								Instruction c1 = new_instruction("move ", "$a0 ", $1->first->result, NULL);
								Instruction c2 = new_instruction("li ", "$v0 ", "1", NULL);
								Instruction c3 = new_instruction("syscall", NULL, NULL, NULL);
								linkCodeList($$, $1);
								insertInstruction(c1, $$);
								insertInstruction(c2, $$);
								insertInstruction(c3, $$);
								delete_register($1);
							}


						| STRING {

								if(checkVariable(t, $1) == 0) {
												insertVariable(&t, $1, 3);
								}
								char *label = getLabel(t, $1);
								Instruction c1 = new_instruction("la ", "$a0 ", label, NULL);
								Instruction c2 = new_instruction("li ", "$v0 ", "4", NULL);
								Instruction c3 = new_instruction("syscall", NULL, NULL, NULL);
								$$ = new_CodeList();
								insertInstruction(c1, $$);		// la $a0, _expresion
								insertInstruction(c2, $$);		// li $v0, 4
								insertInstruction(c3, $$);		// syscall;
							}
						;

read_list	: ID	{
								int n = checkVariable(t, $1);
								if(n == 0) {
									printf("variable no encontrada\n");
								} else {
									if (n == 1) {
											char* label = underScore($1);
											Instruction c1 = new_instruction("li ", "$v0 ", "5", NULL);
											Instruction c2 = new_instruction("syscall", NULL, NULL, NULL);
											Instruction c3 = new_instruction("sw ", "$v0 ", label, NULL);
											$$ = new_CodeList();
											insertInstruction(c1, $$);
											insertInstruction(c2, $$);
											insertInstruction(c3, $$);
									} else {
										printf("las constantes no pueden ser identificadores\n");
									}
								}

						}
					| read_list COMA ID {
							if (checkVariable(t, $3) == 0){
								printf("variable no encontrada\n");
							} else {
								$$ = new_CodeList();
								Instruction c1 = new_instruction("li ", "$v0 ", "5", NULL);
								Instruction c2 = new_instruction("syscall", NULL, NULL, NULL);
								Instruction c3 = new_instruction("sw ", "$v0 ", $3, NULL);
								linkCodeList($$, $1);
								insertInstruction(c1, $$);
								insertInstruction(c2, $$);
								insertInstruction(c3, $$);
							}
						}
					;



boolean:		 expresion GTOREQ expresion {
													$$ = new_CodeList();
													char* registro = current_register();
													linkCodeList($$, $1);
													linkCodeList($$, $3);
													Instruction c1 = new_instruction("sge", registro, $1->last->result, $3->last->result);
													insertInstruction(c1, $$);
													delete_register($1);
													delete_register($3);
								}
						| expresion LSSROREQ expresion {
													$$ = new_CodeList();
													char* registro = current_register();
													linkCodeList($$, $1);
													linkCodeList($$, $3);
													Instruction c1 = new_instruction("sle", registro,$1->last->result, $3->last->result);
													insertInstruction(c1, $$);
													delete_register($1);
													delete_register($3);
												}
						| expresion GREATERTHAN expresion {
													$$ = new_CodeList();
													char* registro = current_register();
													linkCodeList($$, $1);
													linkCodeList($$, $3);
													Instruction c1 = new_instruction("sgt", registro, $1->last->result, $3->last->result);
													insertInstruction(c1, $$);
													delete_register($1);
													delete_register($3);
							}
						| expresion LESSERTHAN expresion {
													$$ = new_CodeList();
													char* registro = current_register();
													linkCodeList($$, $1);
													linkCodeList($$, $3);
													Instruction c1 = new_instruction("slt", registro, $1->last->result, $3->last->result);
													insertInstruction(c1, $$);
													delete_register($1);
													delete_register($3);
							}
						| expresion IGIG expresion {
												$$ = new_CodeList();
												char* registro = current_register();
												linkCodeList($$, $1);
												linkCodeList($$, $3);
												Instruction c1 = new_instruction("seq", registro, $1->last->result, $3->last->result);
												delete_register($1);
												delete_register($3);

							}

						| expresion DIFFERENT expresion {
													$$ = new_CodeList();
													char* registro = current_register();
													linkCodeList($$, $1);
													linkCodeList($$, $3);
													Instruction c1 = new_instruction("sne", registro, $1->last->result, $3->last->result);
													insertInstruction(c1, $$);
													delete_register($1);
													delete_register($3);
												}


						| boolean AND boolean {
							$$ = new_CodeList();
							char* registro = current_register();
							linkCodeList($$, $1);
							linkCodeList($$, $3);
							Instruction c1 = new_instruction("and", registro, $1->last->result, $3->last->result);
							insertInstruction(c1, $$);
							delete_register($1);
							delete_register($3);
							}
						| boolean OR boolean {
											$$ = new_CodeList();
											char* registro = current_register();
											linkCodeList($$, $1);
											linkCodeList($$, $3);
											Instruction c1 = new_instruction("or", registro, $1->last->result, $3->last->result);
											insertInstruction(c1, $$);
											delete_register($1);
											delete_register($3);
										}
						 | LEFTPAREN boolean RIGHTPAREN {
							$$ = new_CodeList();
							linkCodeList($$, $2);
							$$->first->result = $2->first->result;
							$$->last->result = $2->last->result;

							}

							| expresion {
								$$ = new_CodeList();
								linkCodeList($$, $1);
							}
							;



expresion	: expresion PLUS expresion {
						char* reg = current_register();
						Instruction c = new_instruction("add ",reg,  $1->last->result, $3->last->result);
						$$ = new_CodeList();
						linkCodeList($$, $1);
						linkCodeList($$, $3);
						insertInstruction(c, $$);
						delete_register($1);
						delete_register($3);

					 }
					| expresion MINUS expresion {
							char* reg = current_register();
							Instruction c = new_instruction("sub ", reg,  $1->last->result, $3->last->result);
							$$ = new_CodeList();
							linkCodeList($$, $1);
							linkCodeList($$, $3);
							insertInstruction(c, $$);
							delete_register($1);
							delete_register($3);
						}

					| expresion ASTERISC expresion {
							char* reg = current_register();
							Instruction c = new_instruction("mul ",reg , $1->last->result, $3->last->result);
							$$ = new_CodeList();
							linkCodeList($$, $1);
							linkCodeList($$, $3);

							insertInstruction(c, $$);
							delete_register($1);
							delete_register($3);
						}
					| expresion SLASH expresion {
						 char* reg = current_register();
						 Instruction c = new_instruction("div ", reg, $1->last->result, $3->last->result);
						 $$ = new_CodeList();
						 linkCodeList($$, $1);
						 linkCodeList($$, $3);

						 insertInstruction(c, $$);
						 delete_register($1);
						 delete_register($3);

						}
					| MINUS expresion %prec UMINUS {
						 char* reg = current_register();
						 Instruction c = new_instruction("neg ", reg, $2->last->result, NULL);
						 linkCodeList($$, $2);
						 insertInstruction(c, $$);
						}
					| LEFTPAREN expresion RIGHTPAREN {
								$$ = new_CodeList();
								linkCodeList($$, $2);
								$$->first->result = $2->first->result;
								$$->last->result = $2->last->result;
						}



					| ID {
						if (checkVariable(t, $1) == 0) {
											printf("ID %s no declarado\n",$1);
							} else {
									char *reg = current_register();
									$$ = new_CodeList();
									Instruction c = new_instruction("lw ", reg, underScore($1), NULL);
									insertInstruction(c, $$);
							}

						}

					| NUM { $$ = new_CodeList();															  // Creamos una nuevo codigo de ensamblador
									char * reg = current_register();												  // Creamos un registro actual, el primero que este libre
									Instruction c = new_instruction("li ", reg, $1, NULL);		// Creamos una Instruction de la sentencia de carga inmediata
									insertInstruction(c, $$);																// Insertamos la Instruction en el codigo
									//imprimirlistaCodigo($$);
						}

					;



%%

int yyerror(const char *msg) {
	fprintf(stderr, " %s en linea : %d\n", msg, yylineno);
	return 0;
}

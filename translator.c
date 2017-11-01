//  traductor.c
//  Traductor
//
//  Created by Morad on 3/4/17.
//  Copyright © 2017 Morad Abbou Azaz. All rights reserved.
//  Así que ya sabes, copiate mi codigo e irás a juicio :P

#include "translator.h"
#include <string.h>
int _register[10]={0,0,0,0,0,0,0,0,0,0};
int counter = 1;




/**
 Esta funcion se encarga de crear una nueva tupla
 Toma como parametros la operacion, el result, y los dos argumentos
 Dependiendo de la operacion, existe la posibilidad de que el arg2 sea nulo
 ya que hay operaciones que solo necesitan un argumento
, por ejemplo, (jal $ra)
 Para ello reserva la memoria necesaria y copia los argumentos
 */
Instruction new_instruction(char* _op, char* _result, char * _arg1, char* _arg2) {

    Instruction c = malloc(sizeof(struct instruction));
    c->op = _op;
    c->arg1 = _arg1;
    c->arg2 = _arg2;
    c->result = _result;
    c->next = NULL;
    return c;
}

/**
 Crea una nueva CodeList
 Sus campos estan inicialmente nulos
 */
CodeList new_CodeList(){
    CodeList t = malloc(sizeof(struct codeList));
    t->first = NULL;
    t->last = NULL;
    return t;
}


/**
 Crea una etiqueta para el codigo de ensamblador
 */
char* create_label() {
    char* aux = (char*)malloc(sizeof(char)*10);
    sprintf(aux, "Label%d", counter);
    counter++;
    return strdup(aux);
}

/**
 Inserta una instruction en una CodeList
 Comprueba que la last CodeList sea nula. En ese caso lo que hace es insertar
 la instruction en la last instruction de la CodeList y su nextuiente.
 En caso contrario se inserta la instruction en ambas instructions de la CodeLists.
 */
void insertInstruction(Instruction instruction, CodeList _codeList) {
  CodeList aux = _codeList;
    if (aux->last == NULL) {
      aux->first = instruction;
      aux->last = instruction;

    } else {
      aux->last->next = instruction;
      aux->last = instruction;
    }
   _codeList = aux;
}

/**
 Enlaza dos CodeLists.
 Si la en la first instruction de la CodeList t no es nula :
    - si la first instruction de la CodeList principal es nula:
        - Se pone la primea instruction de t en la de principal
        - se pone la last CodeList de t en la de principal
    - En caso:
        - Se pone la first de t en la nextuiente de la de last de principal
        - Se pone la utlima de t en la last de principal
 */
void linkCodeList(CodeList main, CodeList _list) {
    if (_list->first != NULL) {
        if (main->first == NULL) {
            main->first = _list->first;
            main->last = _list->last;
        } else {
            main->last->next = _list->first;
            main->last = _list->last;
        }
    }
}

/**
 Liberamos la CodeList
 */
void freeCodeList(CodeList _list) {
    CodeList aux = _list;
    Instruction inst = _list->first;
    while (inst != NULL){
        _list->first = _list->first->next;
        free(inst);
        inst = _list->first;
    }
    _list = aux;
}

/**
 Imprime todo el codigo de la CodeList
 */
void printCodeList(CodeList _list) {
    Instruction aux = _list->first;
    printf("\t");
    printf( "\n########################\n");
    printf( "# Seccion de codigo \n");
    printf("     .text\n\n");
    printf("     .globl main\n");
    printf("main:\n");

    while (aux != NULL){

        if (aux->op != NULL){
            if (aux->op[0] == '$') printf(" %s:", aux->op);
            else printf("%s", aux->op);
        } else {
          printf("aux->op es NULO\n");
        }

        if (aux->result != NULL) printf( " %s,", aux->result);
        if (aux->arg1 != NULL) printf( " %s", aux->arg1);
        if (aux->arg2 != NULL) printf(", %s", aux->arg2);
        printf("\n");
        aux = aux->next;
    }
    printf("\n########################\n");
    printf("# Fin\n");
    printf("	jr $ra\n");

}

void freeCodeLists(CodeList _list1, CodeList _list2) {
    Instruction aux1 = _list1->first;
    Instruction aux2 = _list2->first;
    printf("\t");
    printf( "\n########################\n");
    printf( "# Seccion de codigo \n");
    printf("     .text\n\n");
    printf("     .globl main\n");
    printf("main:\n");

    while (aux1 != NULL){

        if (aux1->op != NULL){

            if (aux1->op[0] == '$') printf(" %s:", aux1->op);
            else printf("     %s", aux1->op);
        }

        if (aux1->result != NULL) printf( " %s,", aux1->result);
        if (aux1->arg1 != NULL) printf( " %s", aux1->arg1);
        if (aux1->arg2 != NULL) printf(", %s", aux1->arg2);
        printf("\n");
        aux1 = aux1->next;
    }


    while (aux2 != NULL){

        if (aux2->op != NULL){

            if (aux2->op[0] == 'L') printf(" %s:", aux2->op);
            else printf("     %s", aux2->op);
        }

        if (aux2->result != NULL) printf( " %s,", aux2->result);
        if (aux2->arg1 != NULL) printf( " %s", aux2->arg1);
        if (aux2->arg2 != NULL) printf(", %s", aux2->arg2);
        printf("\n");
        aux2 = aux2->next;
    }


    printf("\n########################\n");
    printf("# Fin\n");
    printf("	jr $ra\n");

}


/**
 Esta funcion devuelve el primer _register que no esta siendo usado
 Para ello recorre el array de _registers usados (array de booleanos)
 y el que esté en desuso se escoge.
 */
char *current__register() {
    char *reg = (char *)malloc(sizeof(char)*10);
    int i = 0;
    for (; i < 10; i++) {
        if (_register[i] == 0) {
            _register[i] = 1;
            sprintf(reg, "$t%d", i);
            return reg;
        }
    }
    return NULL;
}

/**

 */

void delete__register(CodeList _codeList) {
    if (_codeList->last->result == NULL) {
        return;
    }else {
        char * dest = _codeList->last->result;
        int position = dest[2] - '0';
        _register[position] = 0;
    }
}

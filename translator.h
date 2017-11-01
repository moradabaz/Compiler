//
//  traductor.h
//  Traductor
//
//  Created by Morad on 3/4/17.
//  Copyright © 2017 Morad Abbou Azaz. All rights reserved.
//

#ifndef translator_h
#define translator_h

#include <stdio.h>
#include <stdlib.h>


typedef struct instruction * Instruction;
typedef struct codeList * CodeList;



/**
 Una instruction es una estructura de datos que contiene una sentencia en ensamblador
 Tiene una operacion op que puede ser por ejemplo, por ejemplo (beg, slt, add)
 y dos argumentos arg1 y arg2 que son los registros que usamos en una sentencia
 en ensamblador ($a0, $a1, $t0,...)
 y un result que sera el registro result del resultado de la operacion de los dos
 argumentos
 */
struct instruction {
    char * op;
    char * arg1;
    char * arg2;
    char * result;
    Instruction next;
};

/**
 Una CodeList es una estructura de datos que contiene dos instruction
 una first y otra last para despues así enlazar los codigos de las instructions
 La CodeList es la estructura de datos que va a contener TODO EL CODIGO ENSAMBLADOR
 y se iran añadiendo instructions de manera anidada.
 */
struct codeList {
    Instruction first;
    Instruction last;
};

// LAS FUNCIONES SE EXPLICAN EN LE .c

/**
  Crea una new instruction que contiene una sentencia en ensamblador
  Para ello reserva la memoria necesaria.
*/
Instruction new_instruction(char * _op, char* _result, char* _arg1, char* _arg2);

CodeList new_CodeList();

char* create_label();

void insertInstruction(Instruction instruction, CodeList _codeList);

void linkCodeList(CodeList main, CodeList _list);

void freeCodeList(CodeList _list);

void printCodeList(CodeList _list);

void printCodeLists(CodeList _list1, CodeList _list2);


char *current_register();

void delete_register(CodeList _codeList);



#endif /* traductor_h */

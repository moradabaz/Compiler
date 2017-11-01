#ifndef _LIST_H
#define _LIST_H

typedef struct listRep * list;
list createList(); // crearLista
void eraseList(list l); // borrarLista
void insertVariable(list *l,char *name, int valor); // insertarVariable
int checkVariable(list l,char *name); // checkVariable
char* getLabel(list t, char *strg); //
char* underScore(char *strg); // barra
void printVariables(list t); //imprimirVariables
char* str_label();
struct listRep * getList(list l, char *name);

#endif

#include "list.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct listRep {
    char *name;
    char *str;
    int value;
    struct listRep *next;
};

list createList() {
    return NULL;
}

int label_number = 1;


void eraseList(list l) {
    struct listRep *aux = l;
    while(aux != NULL) {
        free(aux->name); // Viene de strdup calculador.l
        l = aux;
        aux = aux->next;
        free(l);
    }
}

struct listRep * getList(list l, char *name) {
  struct  listRep *aux = l;
    while (aux != NULL) {
        if (!strcmp(aux->name, name)) {
            // Encontrado!
            return aux;
        }
        aux = aux->next;
    }
    return NULL;
}

void insertVariable(list *l,char *name, int value) {
    struct listRep *aux = getList(*l, name);
    if (aux == NULL) {
        // Nodo nuevo
        aux = (struct listRep *)malloc(sizeof(struct listRep));
        if (aux == NULL) {
            // No hay memoria!
            printf("No memory!\n");
            exit(1);
        }
        aux->name = name;
        aux->value = value;

        if(aux->value == 3){
          aux->str = str_label();
        }
        else {
          aux->str = underScore(aux->name);
        }
        aux->next = *l;
        *l = aux;
    }
}

int checkVariable(list l,char *name) {
    struct listRep *aux = getList(l,name);
    if (aux == NULL) return 0;
    return aux->value;
}


char* underScore(char *strg){
	char* cad =  (char*)malloc(sizeof(char)*10);
	sprintf(cad, "_%s",strg);
	return strdup(cad);
}


char* str_label(){
	char cad[10];
	sprintf(cad, "$str%d", label_number);
	label_number++;
	return strdup(cad);
}


char* getLabel(list l, char* name) {
  list aux = l;
    	while(aux){
		if(strcmp(aux->name, name) != 0){	//!=
			aux=aux->next;
		}else if(strcmp(aux->name, name) == 0) //=
			return aux->str;
	}
	return NULL;
}

void printVariables(list t){

    list aux = t;
  	printf("###############################\n");
  	printf("# Data part\n");
  	printf("\t .data\n\n");

    while (aux != NULL){
        if(aux->value == 3){
	          printf("%s:\n \t .asciiz %s \n", aux->str, aux->name);
            aux = t;
            t = t->next;
            free(aux);
        }else{
            printf("%s: \n \t .word 0 \n", aux->str);
            aux = t;
            t = t->next;
            free(aux);

        }
	         aux = aux->next;
    }
}

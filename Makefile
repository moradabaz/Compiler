# Instrucciones de compilación
scanner : main.c lex.yy.c  miniC.tab.c list.h list.c translator.h translator.c
	gcc -g main.c lex.yy.c  miniC.tab.c list.c translator.c -ll -lm -o $@

miniC.tab.c miniC.tab.h: miniC.y
	bison -d  -t miniC.y

lex.yy.c : miniC.l miniC.tab.h
	flex --yylineno miniC.l

clean :
	rm -f miniC.tab.* scanner lex.yy.c

run : scanner prueba.c
	./scanner prueba.c > file.s

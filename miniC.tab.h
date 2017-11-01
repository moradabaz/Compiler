/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ID = 258,
     NUM = 259,
     STRING = 260,
     OR = 261,
     AND = 262,
     DO = 263,
     FUNC = 264,
     VAR = 265,
     LET = 266,
     IF = 267,
     ELSE = 268,
     WHILE = 269,
     PRINT = 270,
     READ = 271,
     SEMICOLON = 272,
     COMA = 273,
     PLUS = 274,
     MINUS = 275,
     EQUAL = 276,
     LEFTPAREN = 277,
     RIGHTPAREN = 278,
     RCURLYBRACKET = 279,
     LCURLYBRACKET = 280,
     FOR = 281,
     SLASH = 282,
     ASTERISC = 283,
     UMINUS = 284,
     DIFFERENT = 285,
     LSSROREQ = 286,
     GTOREQ = 287,
     LESSERTHAN = 288,
     GREATERTHAN = 289,
     IGIG = 290
   };
#endif
/* Tokens.  */
#define ID 258
#define NUM 259
#define STRING 260
#define OR 261
#define AND 262
#define DO 263
#define FUNC 264
#define VAR 265
#define LET 266
#define IF 267
#define ELSE 268
#define WHILE 269
#define PRINT 270
#define READ 271
#define SEMICOLON 272
#define COMA 273
#define PLUS 274
#define MINUS 275
#define EQUAL 276
#define LEFTPAREN 277
#define RIGHTPAREN 278
#define RCURLYBRACKET 279
#define LCURLYBRACKET 280
#define FOR 281
#define SLASH 282
#define ASTERISC 283
#define UMINUS 284
#define DIFFERENT 285
#define LSSROREQ 286
#define GTOREQ 287
#define LESSERTHAN 288
#define GREATERTHAN 289
#define IGIG 290




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 16 "miniC.y"
{
	char *str;
	struct codeList * l;
}
/* Line 1529 of yacc.c.  */
#line 124 "miniC.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;


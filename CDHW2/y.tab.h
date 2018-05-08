/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

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

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    COMMA = 258,
    SEMICOLON = 259,
    COLON = 260,
    R_PARAN = 261,
    L_PARAN = 262,
    L_BRACKED = 263,
    R_BRACKED = 264,
    NOT = 265,
    AND = 266,
    OR = 267,
    LT = 268,
    LE = 269,
    LG = 270,
    GE = 271,
    GT = 272,
    ET = 273,
    ADD = 274,
    SUB = 275,
    MUL = 276,
    DIV = 277,
    MOD = 278,
    ASSIGN = 279,
    ARRAY = 280,
    BEGIN_TO = 281,
    BOOLEAN = 282,
    DEF = 283,
    DO = 284,
    ELSE = 285,
    END = 286,
    FALSE = 287,
    FOR = 288,
    INTERGER = 289,
    IF = 290,
    OF = 291,
    PRINT = 292,
    READ = 293,
    REAL = 294,
    STRING = 295,
    THEN = 296,
    TO = 297,
    TRUE = 298,
    RETURN = 299,
    VAR = 300,
    WHILE = 301,
    ID = 302,
    INT_CON = 303,
    FLOAT_CON = 304,
    SCI_INT_CON = 305,
    STRING_CON = 306
  };
#endif
/* Tokens.  */
#define COMMA 258
#define SEMICOLON 259
#define COLON 260
#define R_PARAN 261
#define L_PARAN 262
#define L_BRACKED 263
#define R_BRACKED 264
#define NOT 265
#define AND 266
#define OR 267
#define LT 268
#define LE 269
#define LG 270
#define GE 271
#define GT 272
#define ET 273
#define ADD 274
#define SUB 275
#define MUL 276
#define DIV 277
#define MOD 278
#define ASSIGN 279
#define ARRAY 280
#define BEGIN_TO 281
#define BOOLEAN 282
#define DEF 283
#define DO 284
#define ELSE 285
#define END 286
#define FALSE 287
#define FOR 288
#define INTERGER 289
#define IF 290
#define OF 291
#define PRINT 292
#define READ 293
#define REAL 294
#define STRING 295
#define THEN 296
#define TO 297
#define TRUE 298
#define RETURN 299
#define VAR 300
#define WHILE 301
#define ID 302
#define INT_CON 303
#define FLOAT_CON 304
#define SCI_INT_CON 305
#define STRING_CON 306

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

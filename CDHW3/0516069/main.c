/**
 * Introduction to Compiler Design by Prof. Yi Ping You
 * Prjoect 2 main function
 */

#include <stdio.h>
#include <stdlib.h>
#include "header.h"
#include "symtab.h"

extern struct SymTable *symbolTable;
extern int yyparse();	/* declared by yacc */
extern FILE* yyin;	/* declared by lex */

int  main( int argc, char **argv )
{
	if( argc != 2 ) {
		fprintf(  stdout,  "Usage:  ./parser  [filename]\n"  );
		exit(0);
	}

	FILE *fp = fopen( argv[1], "r" );

	if( fp == NULL )  {
		fprintf( stdout, "Open  file  error\n" );
		exit(-1);
	}

	symbolTable = (struct SymTable *)malloc(sizeof(struct SymTable));
	initSymTab( symbolTable );

	
	yyin = fp;
	yyparse();	/* primary procedure of parser */
	
	exit(0);
}


%{
#include <stdio.h>
#include <stdlib.h>

extern int linenum;             /* declared in lex.l */
extern FILE *yyin;              /* declared by lex */
extern char *yytext;            /* declared by lex */
extern char buf[256];           /* declared in lex.l */
%}

%token COMMA SEMICOLON COLON R_PARAN L_PARAN L_BRACKED R_BRACKED
%left NOT
%left AND
%left OR
%left LT LE LG GE GT ET
%left ADD SUB
%left MUL DIV MOD 
%token ASSIGN
%token ARRAY BEGIN_TO BOOLEAN DEF DO ELSE END FALSE FOR INTERGER IF OF PRINT READ REAL STRING THEN TO TRUE RETURN VAR WHILE
%token ID INT_CON FLOAT_CON SCI_INT_CON STRING_CON

%%

program		: programname SEMICOLON programbody END ID
		;

programname	: identifier
		;

programbody	: var_dec_list func_dec_list compound
	    	;

functionname	: identifier
	     	;

argument	: argument SEMICOLON arg_dec
	 	| arg_dec
		| /*empty*/
		;

identifier	: ID
	   	;

arg_dec		: identifier_list COLON scalar_type
	 	;

func_dec_list	: func_dec_list function_dec
		| /*empty*/
		;

function_dec	: functionname L_PARAN argument R_PARAN return_val SEMICOLON compound END ID
	 	;

return_val	: COLON scalar_type
	   	| /*empty*/
		;

var_dec_list	: var_dec_list var_dec
	 	| var_dec_list const_dec
		| /*empty*/
	 	;

var_dec		: VAR identifier_list COLON scalar_type SEMICOLON
		;

identifier_list	: identifier_list COMMA identifier
		| identifier
		;

const_dec	: VAR identifier_list COLON literal_con SEMICOLON
	  	;

state_list	: state_list statement
		| /*empty*/
		;

statement	: compound
	  	| simple
		| condition
		| while_loop
		| for_loop
		| return_state
	  	| func_invol SEMICOLON
		;

compound	: BEGIN_TO var_dec_list state_list END
	 	;

simple		: var_refer ASSIGN expression SEMICOLON
		| PRINT expression SEMICOLON
		| READ var_refer SEMICOLON
		;

condition	: IF expression THEN state_list ELSE state_list END IF
	  	| IF expression THEN state_list END IF
		;

while_loop	: WHILE expression DO state_list END DO
	   	;

for_loop	: FOR identifier ASSIGN INT_CON TO INT_CON DO state_list END DO
	 	;

return_state	: RETURN expression SEMICOLON
	     	;

func_invol	: functionname L_PARAN expr_list R_PARAN
	   	;

expr_list	: expr_list COMMA expression
	  	| expression
		| /*empty*/
	  	;

var_refer	: var_refer L_BRACKED INT_CON R_BRACKED
	 	| identifier
	  	;

expression	: expression MUL expression
	   	| expression DIV expression
	   	| expression MOD expression
	   	| expression ADD expression
	   	| expression SUB expression
	   	| expression LT expression
	   	| expression LE expression
	   	| expression LG expression
	   	| expression GE expression
	   	| expression GT expression
	   	| expression ET expression
	   	| NOT expression
	   	| expression AND expression
	   	| expression OR expression
	   	| L_PARAN expression R_PARAN
	   	| SUB expression
		| var_refer
		| literal_con
		| func_invol
	   	;

scalar_type	: INTERGER
      		| REAL
		| STRING
		| BOOLEAN
	 	| ARRAY INT_CON TO INT_CON OF scalar_type
		;

literal_con	: INT_CON
	    	| FLOAT_CON
		| SCI_INT_CON
		| STRING_CON
		| TRUE
		| FALSE
		;

%%

int yyerror( char *msg )
{
        fprintf( stderr, "\n|--------------------------------------------------------------------------\n" );
	fprintf( stderr, "| Error found in Line #%d: %s\n", linenum, buf );
	fprintf( stderr, "|\n" );
	fprintf( stderr, "| Unmatched token: %s\n", yytext );
        fprintf( stderr, "|--------------------------------------------------------------------------\n" );
        exit(-1);
}

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
	
	yyin = fp;
	yyparse();

	fprintf( stdout, "\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	fprintf( stdout, "|  There is no syntactic error!  |\n" );
	fprintf( stdout, "|--------------------------------|\n" );
	exit(0);
}

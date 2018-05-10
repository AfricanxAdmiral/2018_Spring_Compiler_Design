%{
/**
 * Introduction to Compiler Design by Prof. Yi Ping You
 * Project 2 YACC sample
**/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symtab.h"

extern int linenum;		/* declared in lex.l */
extern FILE *yyin;		/* declared by lex */
extern char *yytext;		/* declared by lex */
extern char buf[256];		/* declared in lex.l */
extern int yylex(void);
int yyerror(char* );

int scope = 0;
int Opt_D = 1;

char fileName[256];

struct SymTable *symbolTable;	// main symbol table

__BOOLEAN paramError;		// indicate is parameter have any error

struct PType *funcReturn;	// record function's return type, used at 'return statement' production rule

%}


%union {
	int intVal;
	double realVal;
	//__BOOLEAN booleanVal;
	char *lexeme;
	struct idNode_sem *id;
	//SEMTYPE type;
	struct ConstAttr *constVal;
	struct PType *ptype;
	struct FuncAttr *par;
	struct expr_sem *exprs;
	/*struct var_ref_sem *varRef; */
	struct expr_sem_node *exprNode;
};

/* tokens */
%token ARRAY
%token BEG
%token BOOLEAN
%token DEF
%token DO
%token ELSE
%token END
%token FALSE
%token FOR
%token INTEGER
%token IF
%token OF
%token PRINT
%token READ
%token REAL
%token RETURN
%token STRING
%token THEN
%token TO
%token TRUE
%token VAR
%token WHILE

%token OP_ADD
%token OP_SUB
%token OP_MUL
%token OP_DIV
%token OP_MOD
%token OP_ASSIGN
%token OP_EQ
%token OP_NE
%token OP_GT
%token OP_LT
%token OP_GE
%token OP_LE
%token OP_AND
%token OP_OR
%token OP_NOT

%token MK_COMMA
%token MK_COLON
%token MK_SEMICOLON
%token MK_LPAREN
%token MK_RPAREN
%token MK_LB
%token MK_RB

%token <lexeme>ID
%token <intVal>INT_CONST 
%token <realVal>FLOAT_CONST
%token <realVal>SCIENTIFIC
%token <lexeme>STR_CONST

%type<id> id_list
%type<constVal> literal_const
%type<ptype> type scalar_type array_type opt_type
%type<par> param param_list opt_param_list
/*%type<exprs> var_ref boolean_expr boolean_term boolean_factor relop_expr expr term factor boolean_expr_list opt_boolean_expr_list*/
%type<intVal> int_const


/* start symbol */
%start program
%%

program			: ID
	  			{
				 struct SymNode *newNode = createProgramNode($1, scope);
				 insertTab(symbolTable, newNode);
				}
	  		  MK_SEMICOLON 
			  program_body
			  END
				{
				 if(Opt_D) printSymTable(symbolTable, scope);
				}
			  ID
			;

program_body		: opt_decl_list opt_func_decl_list compound_stmt
			;

opt_decl_list		: decl_list
			| /* epsilon */
			;

decl_list		: decl_list decl
			| decl
			;

decl			: VAR id_list MK_COLON scalar_type MK_SEMICOLON       /* scalar type declaration */
       				{
				 struct SymNode *newNode;
				 struct idNode_sem *itr;
				 for(itr = $2; itr != 0; itr = itr->next)
				 {
					if(verifyRedeclaration(symbolTable, itr->value, scope) == __FALSE)
					{
						printf("<Error> found in Line %d: symbol '%s' is redeclared\n", linenum, itr->value);
					}
					else
					{
						newNode = createVarNode(itr->value, scope, $4);
						insertTab(symbolTable, newNode);
					}
				 }
				}
			| VAR id_list MK_COLON array_type MK_SEMICOLON        /* array type declaration */
				{
				 struct SymNode *newNode;
				 struct idNode_sem *itr;
				 for(itr = $2; itr != 0; itr = itr->next)
				 {
					if(verifyRedeclaration(symbolTable, itr->value, scope) == __FALSE)
					{
						printf("<Error> found in Line %d: symbol '%s' is redeclared\n", linenum, itr->value); 
					}
					else
					{
						newNode = createVarNode(itr->value, scope, $4);
						insertTab(symbolTable, newNode);
					}
				 }
				}
			| VAR id_list MK_COLON literal_const MK_SEMICOLON     /* const declaration */
				{
				 struct SymNode *newNode;
				 struct idNode_sem *itr;
				 struct PType *type = createPType($4->category);
				 for(itr = $2; itr != 0; itr = itr->next)
				 {
					if(verifyRedeclaration(symbolTable, itr->value, scope) == __FALSE)
					{
						printf("<Error> found in Line %d: symbol '%s' is redeclared\n", linenum, itr->value); 
					}
					else
					{
						newNode = createConstNode(itr->value, scope, type, $4);
						insertTab(symbolTable, newNode);
					}
				 }
				}
			;

int_const		: INT_CONST
			;

literal_const		: int_const		{ int val = $1; $$ = createConstAttr(INTEGER_t, &val); }
			| OP_SUB int_const	{ int val = -$2; $$ = createConstAttr(INTEGER_t, &val); }
			| FLOAT_CONST		{ float val = $1; $$ = createConstAttr(REAL_t, &val); }
			| OP_SUB FLOAT_CONST	{ float val = -$2; $$ = createConstAttr(REAL_t, &val); }
			| SCIENTIFIC		{ float val = $1; $$ = createConstAttr(REAL_t, &val); }
			| OP_SUB SCIENTIFIC	{ float val = -$2; $$ = createConstAttr(REAL_t, &val); }
			| STR_CONST		{ $$ = createConstAttr(STRING_t, $1); }
			| TRUE			{ __BOOLEAN val = __TRUE; $$ = createConstAttr(BOOLEAN_t, &val); }
			| FALSE			{ __BOOLEAN val = __FALSE; $$ = createConstAttr(BOOLEAN_t, &val); }
			;

opt_func_decl_list	: func_decl_list
			| /* epsilon */
			;

func_decl_list		: func_decl_list func_decl
			| func_decl
			;

func_decl		: ID MK_LPAREN opt_param_list MK_RPAREN opt_type MK_SEMICOLON
	   			{
					struct SymNode *newNode;
					if(verifyRedeclaration(symbolTable, $1, scope) == __FALSE)
					{
						printf("<Error> found in Line %d: symbol '%s' is redeclared\n", linenum, $1);
					}
					else
					{
						newNode = createFuncNode($1, scope, $5, $3);
						insertTab(symbolTable, newNode);
					}
				}
			  compound_stmt
			  END ID
			;

opt_param_list		: param_list
			| /* epsilon */	{ $$ = createFuncAttr(0, 0); }
			;

param_list		: param_list MK_SEMICOLON param
	    			{
					addFuncAttr($1, $3);
				}
			| param
			;

param			: id_list MK_COLON type
				{
				 struct SymNode *newNode;
				 struct idNode_sem *itr;
				 for(itr = $1; itr != 0; itr = itr->next)
				 {
					if(verifyRedeclaration(symbolTable, itr->value, scope+1) == __FALSE)
					{
						printf("<Error> found in Line %d: symbol '%s' is redeclared\n", linenum, itr->value); 
					}
					else
					{
						newNode = createParamNode(itr->value, scope+1, $3);
						insertTab(symbolTable, newNode);
					}
				 }
				 $$ = createFuncAttr($1, $3);
				}
			;

id_list			: id_list MK_COMMA ID
	  			{
				 idlist_addNode($1, $3);
				}
			| ID
				{
				 $$ = createIdList($1);
				}
			;

opt_type		: MK_COLON type	{ $$ = $2; }
			| /* epsilon */	{ $$ = createPType(VOID_t); }
			;

type			: scalar_type
			| array_type
			;

scalar_type		: INTEGER	{ $$ = createPType(INTEGER_t); }
			| REAL		{ $$ = createPType(REAL_t); }
			| BOOLEAN	{ $$ = createPType(BOOLEAN_t); }
			| STRING	{ $$ = createPType(STRING_t); }
			;

array_type		: ARRAY int_const TO int_const OF type
	    			{
				 increaseArrayDim($6, $2, $4);
				 $$ = $6;
				}
			;

stmt			: compound_stmt
			| simple_stmt
			| cond_stmt
			| while_stmt
			| for_stmt
			| return_stmt
			| proc_call_stmt
			;

compound_stmt		: BEG { scope += 1; }
			  opt_decl_list
			  opt_stmt_list
			  END
				{
				 if(Opt_D) printSymTable(symbolTable, scope);
				 deleteScope(symbolTable, scope);
				 scope -= 1;
				}
			;

opt_stmt_list		: stmt_list
			| /* epsilon */
			;

stmt_list		: stmt_list stmt
			| stmt
			;

simple_stmt		: var_ref OP_ASSIGN boolean_expr MK_SEMICOLON
			| PRINT boolean_expr MK_SEMICOLON
			| READ boolean_expr MK_SEMICOLON
			;

proc_call_stmt		: ID MK_LPAREN opt_boolean_expr_list MK_RPAREN MK_SEMICOLON
			;

cond_stmt		: IF boolean_expr THEN
			  opt_stmt_list
			  ELSE
			  opt_stmt_list
			  END IF
			| IF boolean_expr THEN opt_stmt_list END IF
			;

while_stmt		: WHILE boolean_expr DO
			  opt_stmt_list
			  END DO
			;

for_stmt		: FOR ID OP_ASSIGN int_const TO int_const DO
				{
					scope += 1;
					struct SymNode *newNode;
					if(verifyRedeclaration(symbolTable, $2, scope) == __FALSE)
					{
						printf("<Error> found in Line %d: symbol '%s' is redeclared\n", linenum, $2);
					}
					else
					{
						newNode = createLoopVarNode($2, scope);
						insertTab(symbolTable, newNode);
					}
				}
			  opt_stmt_list
				{
				 if(Opt_D) printSymTable(symbolTable, scope);
				 deleteScope(symbolTable, scope);
				 scope -= 1;
				}
			  END DO
			;

return_stmt		: RETURN boolean_expr MK_SEMICOLON
			;

opt_boolean_expr_list	: boolean_expr_list
			| /* epsilon */
			;

boolean_expr_list	: boolean_expr_list MK_COMMA boolean_expr
			| boolean_expr
			;

boolean_expr		: boolean_expr OP_OR boolean_term
			| boolean_term
			;

boolean_term		: boolean_term OP_AND boolean_factor
			| boolean_factor
			;

boolean_factor		: OP_NOT boolean_factor 
			| relop_expr
			;

relop_expr		: expr rel_op expr
			| expr
			;

rel_op			: OP_LT
			| OP_LE
			| OP_EQ
			| OP_GE
			| OP_GT
			| OP_NE
			;

expr			: expr add_op term
			| term
			;

add_op			: OP_ADD
			| OP_SUB
			;

term			: term mul_op factor
			| factor
			;

mul_op			: OP_MUL
			| OP_DIV
			| OP_MOD
			;

factor			: var_ref
			| OP_SUB var_ref
			| MK_LPAREN boolean_expr MK_RPAREN
			| OP_SUB MK_LPAREN boolean_expr MK_RPAREN
			| ID MK_LPAREN opt_boolean_expr_list MK_RPAREN
			| OP_SUB ID MK_LPAREN opt_boolean_expr_list MK_RPAREN
			| literal_const
			;

var_ref			: ID
			| var_ref dim
			;

dim			: MK_LB boolean_expr MK_RB
			;

%%

int yyerror( char *msg )
{
	(void) msg;
	fprintf( stderr, "\n|--------------------------------------------------------------------------\n" );
	fprintf( stderr, "| Error found in Line #%d: %s\n", linenum, buf );
	fprintf( stderr, "|\n" );
	fprintf( stderr, "| Unmatched token: %s\n", yytext );
	fprintf( stderr, "|--------------------------------------------------------------------------\n" );
	exit(-1);
}



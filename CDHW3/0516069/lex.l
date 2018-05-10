/**
 * Introduction to Compiler Design by Prof. Yi Ping You
 * Project 2 Lex Sample
 */

%{

#include <string.h>
#include <math.h>
#include "y.tab.h"

#define LIST strcat( buf, yytext )
#define token(t) { LIST; if (Opt_T) printf("<%s>\n", #t );}
#define tokenChar(t) { LIST; if (Opt_T) printf("<%c>\n", t );}
#define tokenInteger(t, i) { LIST; if (Opt_T) printf("<%s: %d>\n", t, i); }
#define tokenOctInteger(t, i) { LIST; if (Opt_T) printf("<%s: %s>\n", t, i); }
#define tokenFloat(t, i) { LIST; if (Opt_T) printf("<%s: %s>\n", t, i ); }
#define tokenScientific(t, s) { LIST; if ( Opt_T ) printf("<%s: %s>\n", t, s); }
#define tokenString(t, s) { LIST; if (Opt_T) printf("<%s: %s>\n", t, s); }

#define  MAX_LINE_LENG  256

int Opt_S = 1;				/* list source code option */
int Opt_T = 1;				/* list token option */
extern int Opt_D;				/* list symbol table option*/
int linenum = 1;			/* line number */
char buf[MAX_LINE_LENG];		/* source code line buffer */
char strContent[MAX_LINE_LENG];		/* string buffer */

void setPseudoComment( const char * );	/* pseudo comment option switch */

double scientificToFloat( const char *str );
%}

whitespace [ \t]+
letter [A-Za-z]
digit [0-9]
integer 0|[1-9][0-9]*
octal 0[0-7]+
fraction 0|[0-9]*[1-9]
float {integer}"."{fraction}
scientific ({integer}|{float})[Ee][+-]?({integer})
identifier ({letter})({letter}|{digit})*

 /* exclusive start conditions */
%x COMMENT
%x COMMENT_CPP

%%

","				{ tokenChar(','); return MK_COMMA; }
";"				{ tokenChar(';'); return MK_SEMICOLON; }
":"				{ tokenChar(':'); return MK_COLON; }
")"				{ tokenChar(')'); return MK_RPAREN; }
"("				{ tokenChar('('); return MK_LPAREN; }
"["				{ tokenChar('['); return MK_LB;}
"]"				{ tokenChar(']'); return MK_RB; }

"+"				{ tokenChar('+'); return OP_ADD; }
"-"				{ tokenChar('-'); return OP_SUB; }
"*"				{ tokenChar('*'); return OP_MUL; }
"/"				{ tokenChar('/'); return OP_DIV; }
"mod"				{ token(mod); return OP_MOD; }
":="				{ token(:=); return OP_ASSIGN; }
"<"				{ token(<); return OP_LT; }
"<="				{ token(<=); return OP_LE; }
"<>"				{ token(<>); return OP_NE; }
">="				{ token(>=); return OP_GE; }
">"				{ token(>); return OP_GT; }
"="				{ token(=); return OP_EQ; }
"and"				{ token(and); return OP_AND; }
"or"				{ token(or); return OP_OR; }
"not"				{ token(not); return OP_NOT; }

"array"				{ token(KWarray); return ARRAY; }
"begin"				{ token(KWbegin); return BEG; }
"boolean"			{ token(KWboolean); return BOOLEAN; }
"def"				{ token(KWdef); return DEF; }
"do"				{ token(KWdo); return DO; }
"else"				{ token(KWelse); return ELSE; }
"end"				{ token(KWend); return END; }
"false"				{ token(KWfalse); return FALSE; }
"for"				{ token(KWfor); return FOR; }
"integer"			{ token(KWinteger); return INTEGER; }
"if"				{ token(KWif); return IF; }
"of"				{ token(KWof); return OF; }
"print"				{ token(KWprint); return PRINT; }
"read"				{ token(KWread); return READ; }
"real"				{ token(KWreal); return REAL; }
"return"			{ token(KWreturn); return RETURN; }
"string"			{ token(KWstring); return STRING; }
"then"				{ token(KWthen); return THEN; }
"to"				{ token(KWto); return TO; }
"true"				{ token(KWtrue); return TRUE; }
"var"				{ token(KWvar); return VAR; }
"while"				{ token(KWwhile); return WHILE; }

{octal}				{
				 tokenOctInteger("oct_integer",yytext);
				 yylval.intVal = strtol(yytext, '\0', 8);
				 return INT_CONST;
				}

{identifier}			{ 
				 char realID[33];
				 memset(realID, 0, sizeof(realID));
				 strncpy(realID, yytext, 32);
				 tokenString("id", realID);
				 yylval.lexeme = strdup(realID);
				 return ID;
				}

{integer}			{
				 tokenInteger("integer",atoi(yytext));
				 yylval.intVal = atoi(yytext);
				 return INT_CONST;
				}

{float}				{
				 tokenFloat("float",yytext);
				 yylval.realVal = atof(yytext);
				 return FLOAT_CONST;
				}

{scientific}			{
				 tokenScientific("scientific", yytext);
				 yylval.realVal = scientificToFloat(yytext);
				 return SCIENTIFIC;
				}

\"((\"\")|[^\"\n])*\"		{
				LIST;
				size_t wrt_idx = 0;
				size_t rd_idx = 1;
				int quote = 0;
				while( yytext[rd_idx] ){
					if( yytext[rd_idx] == '\"' ){
						if( quote )
							strContent[wrt_idx++] = '\"';
						quote = 1 - quote;
					}
					else
						strContent[wrt_idx++] = yytext[rd_idx];
					rd_idx++;
				}
				strContent[wrt_idx] = '\0';
				yylval.lexeme = strdup(strContent);
				if (Opt_T)
					printf("<%s: %s>\n", "string", strContent);
				return STR_CONST;
				}

"//&"[A-Z][+-][^\n]*		{ /* pseudo comment */
				  LIST;
				  setPseudoComment( yytext );
				}
"//"				{ /* C++ stype comment */
				  LIST;
				  BEGIN COMMENT_CPP;
				}

<COMMENT_CPP>[^\n]+		{
				  LIST;
				}

<COMMENT_CPP>"\n"		{
				  LIST;
				  if( Opt_S )
				  	printf("%d: %s",  linenum,  buf);
				  linenum++;
				  buf[0] = '\0';
				  BEGIN INITIAL;
				}

"/*"				{ /* C-style comment */
				  LIST;
				  BEGIN COMMENT;
				}
<COMMENT>"*/"			{
				  LIST;
				  BEGIN INITIAL;
				}
<COMMENT>"\n"			{
				  LIST;
				  if  (Opt_S)
				  	printf("%d: %s",  linenum,  buf);
				  linenum++;
				  buf[0] = '\0';
				}
<COMMENT>.			{
				  LIST;
				}

{whitespace}			{ 
				  LIST; 
				}

\n 				{
				  LIST;
				  if  (Opt_S)
				  	printf("%d: %s",  linenum,  buf);
				  linenum++;
				  buf[0] = '\0';
		   		}

.				{
				  /* error */
				  printf("error at line %d: bad character \"%s\"\n", linenum, yytext );
				  exit(-1);
				}

%%

void setPseudoComment( const char *text )
{
	/* format : //&[A-Z][+-] */
	switch( text[3] ) {
	 case 'S':			/* Source code */
		if( text[4] == '+' )
			Opt_S = 1;
		else if( text[4] == '-' )
			Opt_S = 0;
		break;
	 case 'T':			/* Tokens */
		if( text[4] == '+' )
			Opt_T = 1;
		else if( text[4] == '-' )
			Opt_T = 0;
	 	break;
	 case 'D':			/* Symbol table */
		if( text[4] == '+' )
			Opt_D = 1;
		else if( text[4] == '-' )
			Opt_D = 0;
	 	break;
	default:
	 	break;
	}

}

double scientificToFloat( const char *str )
{
	double fraction;
	int exponent;
	char buf[256];
	strcpy( buf, str );
	char *token = strtok( buf,"Ee \t\n");
	fraction = atof(token);
	token = strtok( NULL, "Ee \t\n" );
	exponent = atoi( token );

	if( exponent != 0 )
		fraction *= pow(10, exponent);

	return fraction;
}


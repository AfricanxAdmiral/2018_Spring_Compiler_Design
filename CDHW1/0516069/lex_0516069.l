%{
#define LIST               strcat(buf, yytext)
#define token(t)           {LIST; if (Opt_T) printf("<%s>\n", #t);}
#define tokenChar(t)       {LIST; if (Opt_T) printf("<%c>\n", (t));}
#define tokenInteger(t, i) {LIST; if (Opt_T) printf("<%s: %d>\n", #t, (i));}
#define tokenString(t, s)  {LIST; if (Opt_T) printf("<%s: %s>\n", #t, (s));}
#define MAX_LINE_LENG      256

int Opt_S = 1;
int Opt_T = 1;
int linenum = 1;
char buf[MAX_LINE_LENG];
char strbuf[MAX_LINE_LENG];
void duquo(char* str);
%}

nzdigit [1-9]
digit [0-9]
letter [a-zA-Z_]

%x COMMENT
%x STR


%%

[ \t]+			{ LIST; }
"+"			{ token(+); }
"-"			{ token(-); }
"*"			{ token(*); }
"/"			{ token(/); }
"mod"			{ token(mod); }
":="			{ token(:=); }
"<"			{ token(<); }
"<="			{ token(<=); }
"<>"			{ token(<>); }
">="			{ token(>=); }
">"			{ token(>); }
"="			{ token(=); }
"and"			{ token(and); }
"or"			{ token(or); }
"not"			{ token(not); }
"("     		{ tokenChar('('); }
","			{ tokenChar(','); }
";"			{ tokenChar(';'); }
":"			{ tokenChar(':'); }
")"			{ tokenChar(')'); }
"["			{ tokenChar('['); }
"]"			{ tokenChar(']'); }
"begin" 		{ token(KWbegin); }
"print" 		{ token(KWprint); }
"array"			{ token(KWarray); }
"boolean"		{ token(KWboolean); }
"def"			{ token(KWdef); }
"do"			{ token(KWdo); }
"else"			{ token(KWelse); }
"end"			{ token(KWend); }
"false"			{ token(KWfalse); }
"for"			{ token(KWfor); }
"integer"		{ token(KWinteger); }
"if"			{ token(KWif); }
"of"			{ token(KWof); }
"read"			{ token(KWread); }
"real"			{ token(KWreal); }
"string"		{ token(KWstring); }
"then"			{ token(KWthen); }
"to"			{ token(KWto); }
"true"			{ token(KWtrue); }
"return"		{ token(KWreturn); }
"var"			{ token(KWvar); }
"while"			{ token(KWwhile);}

-?0|{nzdigit}{digit}*	{ tokenInteger(integer, atoi(yytext)); }
-?0{digit}+		{ tokenString(oct_integer, yytext); }
{letter}({letter}|{digit})*	{
			  tokenString(id, yytext);
			}
{digit}+\.{digit}+	{ tokenString(float, yytext); }
({digit}+|({digit}*\.{digit}+))([eE][-+]?{digit}+)	{
			  tokenString(scientific, yytext);
			}

\"([^\"]|\"{2})*\"	{
			  strcpy(strbuf,yytext);
			  duquo(strbuf);
			  tokenString(string, strbuf);
			}

"/*"			{
			  LIST;
			  BEGIN COMMENT;
			}
<COMMENT>"\n"		{
			  LIST;
			  if (Opt_S)
			    printf("%d: %s", linenum, buf);
			  linenum++;
			  buf[0] = '\0';
			}
<COMMENT>.		{
			  LIST;
			}
<COMMENT>"*/"		{ 
			  LIST;
			  BEGIN INITIAL;
			}
\/\/&S\+.*		{
			  LIST;
			  Opt_S = 1;
			}
\/\/&S-.*		{
			  LIST;
			  Opt_S = 0;
			}
\/\/&T\+.*		{
			  LIST;
			  Opt_T = 1;
			}
\/\/&T-.*		{
			  LIST;
			  Opt_T = 0;
			}
\/\/.*			{
			  LIST; /*gets the c++ type comment*/
			}
\n      		{
          		  LIST;
          		  if (Opt_S)
            		    printf("%d: %s", linenum, buf);
          		  linenum++;
          		  buf[0] = '\0';
        		}
.       		{
          		  /* error */
          		  printf("error at line %d: bad character \"%s\"\n", linenum, yytext );
          		  exit(-1);
        		}
%%
int main( int argc, char **argv )
{
  if( argc != 2 ) {
    fprintf( stderr, "Usage: ./scanner [filename]\n" );
    exit(0);
  }
	
  FILE *fp = fopen( argv[1], "r" );
  if( fp == NULL ) {
    fprintf( stderr, "Open file error\n" );
    exit(-1);
  }
	
  yyin = fp;

  yylex();

  exit(0);
}

void duquo(char* str){
  int k = 0;
  for(int i = 1; i < strlen(str); i++, k++){
    if(str[i] == '"'){
      str[k] = str[++i];
    }
    else str[k] = str[i];
  }
  str[k] = '\0';
}

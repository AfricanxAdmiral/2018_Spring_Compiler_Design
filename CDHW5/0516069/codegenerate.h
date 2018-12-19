extern int linenum;
extern FILE* outfp;
extern int scope;
extern int hasRead;
extern struct SymTable *symbolTable;
extern char fileName[256];
extern struct insList insList;


struct insList{
	char* list[2048];
	int size;
};
char insBuf[256];

struct loop_stack{
	int stack[100];
	int top;
} ;
struct cond_stack{
	int stack[100];
	int top;
} ;

void initInsList(struct insList);
void pushIns(char* ins);
void GenToList(char* fmt,...);
void GenExprIns();
void ClearExprIns();

void GenProgramStart(char*);
void GenProgramEnd();

void GenLoadExpr(struct expr_sem* expr);
void GenSaveExpr(struct expr_sem* expr,struct expr_sem* RHS);

void GenMethod(char*,int,char*,char*);
void GenGlobalVar(char*,struct PType*);
void GenPrintStart();
void GenPrint(struct expr_sem*);
void GenReadStart();
void GenRead(struct expr_sem*);
void LoadConstToStack(struct ConstAttr*);
void GenArithmetic( struct expr_sem *op1, OPERATOR operator, struct expr_sem *op2);
void GenRelational( struct expr_sem *op1, OPERATOR operator, struct expr_sem *op2);
void GenBoolean( struct expr_sem *op1, OPERATOR operator, struct expr_sem *op2);
void GenFunctionStart(char* id,struct param_sem* params,struct PType* ret);
void GenFunctionEnd(struct PType* ret);
void GenFunctionCall(char* id);
void GenForLoop(char* id,int start,int end);
void GenForLoopEnd(char* id);
void GenCoercion(struct expr_sem* LHS,struct expr_sem* RHS);
void GenNegative(struct expr_sem* expr);

#ifndef _SYMTAB_H_
#define _SYMTAB_H_

#include "header.h"

void initSymTab(struct SymTable *table);
void insertTab(struct SymTable *table, struct SymNode *newNode);
struct SymNode* createLoopVarNode(const char *name,int scope);
struct SymNode* createVarNode(const char *name, int scope, struct PType *type);
struct SymNode* createParamNode(const char *name, int scope, struct PType *type);
struct SymNode* createConstNode(const char *name, int scope, struct PType *pType, struct ConstAttr *constAttr);
struct SymNode* createFuncNode(const char *name, int scope, struct PType *pType, struct FuncAttr *params);
struct SymNode* createProgramNode(const char *name, int scope);

struct PType* createPType(SEMTYPE type);

struct SymNode* lookupSymbol(struct SymTable* table, const char* id, int scope, __BOOLEAN currentScope);

struct FuncAttr *createFuncAttr(struct idNode_sem* ids, struct PType* pType);
void addFuncAttr(struct FuncAttr* lfa, struct FuncAttr* rfa);
struct idNode_sem* createIdList(const char* str);
void idlist_addNode(struct idNode_sem* node, const char* string);

void increaseArrayDim(struct PType* pType, int lo, int hi);

struct ConstAttr *createConstAttr( SEMTYPE type, void *value );

void deleteScope(struct SymTable* table, int scope);

void printType(struct PType* type, int flag);
void printSymTable(struct SymTable *table, int __scope);

__BOOLEAN verifyRedeclaration( struct SymTable *table, const char *str, int scope );

#endif

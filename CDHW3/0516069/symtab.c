#include "header.h"
#include "symtab.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern int linenum;

void initSymTab( struct SymTable *table )
{	int i;
	for( i=0 ; i<HASHBUNCH ; ++i )
		table->entry[i] = 0;

	table->loopVarDepth = 0;
	table->loopVar = 0;
}

void insertTab(struct SymTable* table, struct SymNode* newNode)
{
	struct SymNode* itr = table->entry[0];
	if(!itr) table->entry[0] = newNode;
	else
	{
		for ( ; itr->next != 0; itr = itr->next);
		itr->next = newNode;
		newNode->prev = itr;
	}
}

struct SymNode* createLoopVarNode(const char* name, int scope)
{
	struct SymNode *newNode = (struct SymNode *)malloc( sizeof(struct SymNode) );
	newNode->name = (char*)malloc(sizeof(char) * (strlen(name) + 1));
	strcpy( newNode->name, name );
	newNode->scope = scope;
	newNode->type = createPType(INTEGER_t);
	newNode->category = LOOPVAR_t;
	newNode->attribute = 0;
	newNode->next = 0;
	newNode->prev = 0;
	return newNode;
}

struct SymNode* createVarNode(const char* name, int scope, struct PType* type)
{
	struct SymNode* newNode = (struct SymNode*)malloc(sizeof(struct SymNode));
	newNode->name = (char*)malloc(sizeof(char) * (strlen(name) + 1));
	strcpy(newNode->name, name);
	newNode->scope = scope;
	newNode->type = type;
	newNode->category = VARIABLE_t;
	newNode->attribute = 0;
	newNode->next = 0;
	newNode->prev = 0;
	return newNode;
}

struct SymNode* createParamNode(const char* name, int scope, struct PType* type)
{
	struct SymNode* newNode = (struct SymNode*)malloc(sizeof(struct SymNode));
	newNode->name = (char*)malloc(sizeof(char) * (strlen(name) + 1));
	strcpy(newNode->name, name);
	newNode->scope = scope;
	newNode->type = type;
	newNode->category = PARAMETER_t;
	newNode->attribute = 0;
	newNode->next = 0;
	newNode->prev = 0;
	return newNode;
}

struct SymNode* createConstNode(const char* name, int scope, struct PType* pType, struct ConstAttr* constAttr)
{
	struct SymNode *newNode = (struct SymNode*)malloc(sizeof(struct SymNode));
	newNode->name = (char*)malloc(sizeof(char) * (strlen(name) + 1));
	strcpy(newNode->name, name);
	newNode->scope = scope;
	newNode->type = pType;
	newNode->category = CONSTANT_t;
	newNode->attribute = (union SymAttr*)malloc(sizeof(union SymAttr));
	newNode->attribute->constVal = constAttr;
	newNode->next = 0;
	newNode->prev = 0;
	return newNode;
}

struct SymNode* createFuncNode(const char* name, int scope, struct PType* pType, struct FuncAttr* params)
{
	struct SymNode* newNode = (struct SymNode*)malloc(sizeof(struct SymNode));
	newNode->name = (char *)malloc(sizeof(char)*(strlen(name)+1));
	strcpy( newNode->name, name );
	newNode->scope = scope;
	newNode->type = pType;
	newNode->category = FUNCTION_t;
	newNode->attribute = (union SymAttr*)malloc(sizeof(union SymAttr));
	newNode->attribute->formalParam = params;
	newNode->next = 0;
	newNode->prev = 0;
	return newNode;
}

struct SymNode* createProgramNode(const char* name, int scope)
{
	struct SymNode* newNode = (struct SymNode*)malloc(sizeof(struct SymNode));
	newNode->name = (char *)malloc(sizeof(char)*(strlen(name)+1));
	strcpy( newNode->name, name );
	newNode->scope = scope;
	newNode->type = createPType( VOID_t );
	newNode->category = PROGRAM_t;
	newNode->attribute = 0;
	newNode->next = 0;
	newNode->prev = 0;
	return newNode;
}

struct PType* createPType(SEMTYPE type)
{
	struct PType* result = (struct PType*)malloc(sizeof(struct PType));
	result->isError = __FALSE;
	result->isArray = __FALSE;
	result->type = type;
	result->dimNum = 0;
	result->dim = 0;
	return result;
}

struct FuncAttr* createFuncAttr(struct idNode_sem* ids, struct PType* pType)
{
	struct FuncAttr* result = (struct FuncAttr*)malloc(sizeof(struct FuncAttr));
	struct idNode_sem* itr;
	struct PTypeList* typelist = 0;
	struct PTypeList* ptr;
	int attr_count = 0;
	for(itr = ids; itr != 0; itr = itr->next)
	{
		struct PTypeList* newtype = (struct PTypeList*)malloc(sizeof(struct PTypeList));
		newtype->value = pType;
		newtype->next = 0;
		if(!typelist)
		{
			typelist = newtype;
			attr_count += 1;
		}
		else
		{
			for(ptr = typelist; ptr->next != 0; ptr = ptr->next);
			ptr->next = newtype;
			attr_count += 1;
		}
	}
	result->paramNum = attr_count;
	result->params = typelist;
	return result;
}

void addFuncAttr(struct FuncAttr* lfa, struct FuncAttr* rfa)
{
	struct PTypeList* ptr;
	for(ptr=lfa->params; (ptr->next) != 0; ptr = (ptr->next));
	ptr->next = rfa->params;
	lfa->paramNum += rfa->paramNum;
}

struct idNode_sem *createIdList(const char* string)
{
	struct idNode_sem* newNode = (struct idNode_sem*)malloc(sizeof(struct idNode_sem));
	newNode->value = (char*)malloc(sizeof(char) * (strlen(string) + 1));
	strcpy(newNode->value, string);
	newNode->next = 0;
	return newNode;
}

void idlist_addNode(struct idNode_sem* node, const char* string)
{
	struct idNode_sem *newNode = 0;
	newNode = (struct idNode_sem*)malloc(sizeof(struct idNode_sem));
	newNode->value = (char*)malloc(sizeof(char) * (strlen(string) + 1));
	strcpy(newNode->value, string);
	newNode->next = 0;
	struct idNode_sem* ptr;
	for(ptr=node ;(ptr->next)!=0 ;ptr=(ptr->next));
	ptr->next = newNode;
}

struct ConstAttr *createConstAttr( SEMTYPE type, void *value )
{
	struct ConstAttr *result = (struct ConstAttr *)malloc(sizeof(struct ConstAttr));
	result->category = type;

	result->hasMinus = __FALSE;

	switch( type ) {
	 case INTEGER_t:
		result->value.integerVal = *(int*)value;
		if( *(int*)value < 0 )
			result->hasMinus = __TRUE;
		break;
	 case REAL_t:
		result->value.realVal = *(float*)value;
		if( *(float*)value < 0.0 )
			result->hasMinus = __TRUE;
		break;
	 case STRING_t:
		result->value.stringVal = (char *)malloc(sizeof(char)*(strlen((char *)value)+1));
		strcpy( result->value.stringVal, (char *)value );
		break;
	 case BOOLEAN_t:
		result->value.booleanVal = *(__BOOLEAN*)value;
		break;
	 default:
		/* FIXME */
		break;
	}
	return result;
}

void increaseArrayDim(struct PType* pType, int lo, int hi)
{
	if( pType->isArray == __FALSE ) pType->isArray = __TRUE;
	(pType->dimNum) += 1;
	struct ArrayDimNode* newDim = (struct ArrayDimNode*)malloc(sizeof(struct ArrayDimNode));
	newDim->low = lo;
	newDim->high = hi;
	newDim->size = hi - lo + 1;
	newDim->next = pType->dim;
	pType->dim = newDim;
}

void deleteScope(struct SymTable* table, int scope)
{
	struct SymNode* current = table->entry[0];
	struct SymNode* post = current->next;
	if(!post){ if(current->scope == scope) table->entry[0] = 0; }
	else
	{
		for( ; post != 0; current = post, post = post->next)
		{
			if(current->scope == scope) {
				if(current->prev == 0)
				{
					post->prev = 0;
					table->entry[0] = post;
				}
				else
				{
					current->prev->next = post;
					post->prev = current->prev;
				}
			}
		}
		if(current->scope == scope)
		{
			if(current->prev == 0) table->entry[0] = 0;
			else current->prev->next = 0;
		}
	}
}

void printType(struct PType *type, int flag)
{
	char buffer[50];
	memset(buffer, 0, sizeof(buffer));
	switch(type->type)
	{
		case INTEGER_t:
	 		sprintf(buffer, "integer");
			break;
	 	case REAL_t:
	 		sprintf(buffer, "real");
			break;
	 	case BOOLEAN_t:
	 		sprintf(buffer, "boolean");
			break;
	 	case STRING_t:
	 		sprintf(buffer, "string");
			break;
	 	case VOID_t:
	 		sprintf(buffer, "void");
			break;
	 	default:
			/* FIXME */
			break;
	}

	int i;
	struct ArrayDimNode *ptrr;
	for(i = 0, ptrr = type->dim; i < (type->dimNum); i++, ptrr=(ptrr->next))
	{
		char buf[15];
		if(!i) strcat(buffer, " ");
		memset(buf, 0, sizeof(buf) );
		sprintf(buf, "[%d]", ptrr->size);
		strcat(buffer, buf);
	}
	if (flag) printf("%-17s ", buffer);
	else printf("%s", buffer);
}

void printSymTable( struct SymTable *table, int __scope )
{
	int i;
	for(i = 0; i < 110; i++) printf("=");
	printf("\n");
	printf("%-33s%-11s%-11s%-17s%-11s\n", "Name", "Kind", "Level", "Type", "Attribute");
	for(i = 0; i< 110; i++) printf("-");
	printf("\n");
	struct SymNode *ptr;
	for( ptr=(table->entry[0]) ; ptr!=0 ; ptr=(ptr->next) ) {
		if( ptr->scope == __scope ) {
			printf("%-33s", ptr->name);
			switch( ptr->category ) {
			 	case VARIABLE_t:
					printf("%-11s", "variable");
					break;
			 	case CONSTANT_t:
			 		printf("%-11s", "constant");
					break;
				case PROGRAM_t:
				 	printf("%-11s", "program");
					break;
				case FUNCTION_t:
				 	printf("%-11s", "function");
					break;
				case PARAMETER_t:
				 	printf("%-11s", "parameter");
					break;
				case LOOPVAR_t:
					printf("%-11s", "loop_var");
					break;
				default:
					/* FIXME */
					break;
			}
			if( ptr->scope == 0 ) {
				printf("%d%-10s", ptr->scope, "(global)");
			}
			else {
				printf("%d%-10s", ptr->scope, "(local)");
			}

			printType(ptr->type, 1);

			if(ptr->category == FUNCTION_t)
			{
				struct PTypeList *pTypePtr;
				for(pTypePtr= ptr->attribute->formalParam->params ; pTypePtr != 0; pTypePtr = pTypePtr->next)
				{
					printType( pTypePtr->value, 0 );
					if(pTypePtr->next) printf(", ");
				}
			}
			else if( ptr->category == CONSTANT_t ) {
				switch( ptr->attribute->constVal->category ) {
					 case INTEGER_t:
						printf("%d",ptr->attribute->constVal->value.integerVal);
						break;
					 case REAL_t:
					 	printf("%lf",ptr->attribute->constVal->value.realVal);
						break;
					 case BOOLEAN_t:
					 	if( ptr->attribute->constVal->value.booleanVal == __TRUE )
							printf("true");
						else
							printf("false");
						break;
					 case STRING_t:
					 	printf("\"%s\"",ptr->attribute->constVal->value.stringVal);
						break;
					 default:
						/* FIXME */
						break;
					}
				}

			printf("\n");
		}
	}
	for(i = 0; i< 110; i++) printf("-");
	printf("\n");
}


/**
 * __BOOLEAN currentScope: true: only search current scope
 */

struct SymNode *lookupSymbol( struct SymTable *table, const char *id, int scope, __BOOLEAN currentScope )
{
	struct SymNode *itr = table->entry[0];
	for( ; itr != 0; itr = itr->next)
	{
		if(!strcmp(itr->name, id) && ((itr->scope) == scope)) return itr;
	}
	
	if(scope == 0) return 0;
	else
	{
		if(currentScope == __TRUE) return 0;
		else return lookupSymbol(table, id, scope-1, __FALSE);
	}
}



__BOOLEAN verifyRedeclaration( struct SymTable *table, const char *str, int scope )
{
	__BOOLEAN result = __TRUE;
	if( lookupSymbol( table, str, scope, __TRUE ) == 0 ) {	// only search current scope
		result =  __TRUE;
	}
	else {
		result = __FALSE;
	}
	return result;
}

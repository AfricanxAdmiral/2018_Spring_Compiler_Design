TARGET = parser
OBJECT = lex.yy.c y.tab.c y.tab.h y.output
CC = gcc
CFLAGS = -Wall -Wextra -pedantic -g3
LEX = flex
YACC = yacc
YACCFLAG = -d -v
LIBS = -ly -lfl
RM = rm 

all: $(TARGET)

$(TARGET): lex.yy.c y.tab.c
	$(CC) $(CCFLAGS) $^ -o $(TARGET) $(LIBS)

y.tab.c: parser.y
	$(YACC) $(YACCFLAG) $<

lex.yy.c: lex.l
	$(LEX) $<

.PHONY: clean

clean:
	$(RM) -f $(TARGET) $(OBJECT)

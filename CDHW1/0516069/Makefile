TARGET = scanner
OBJECT = lex.yy.c 
CC     = gcc
CFLAGS = -Wall -Wextra -pedantic -g3
LEX    = flex
LIBS   = -lfl

all: $(TARGET)

$(TARGET): lex.yy.c
	$(CC) $(CCFLAGS) $< -o $(TARGET) $(LIBS)

lex.yy.c: lex_0516069.l
	$(LEX) $<

.PHONY: clean

clean:
	$(RM) -f $(TARGET) $(OBJECT)

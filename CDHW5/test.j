; Line #1: // test1.p
; test1.j
.class public test1
.super java/lang/Object
.field public static _sc Ljava/util/Scanner;
; Line #2: test1;
.field public static a I
.field public static b I
; Line #3: var a, b: integer;
.field public static d Z
; Line #4: var d: boolean;
.method public static foo(I)I
.limit stack 10 ;Sets the maximum size of the operand stack required by the method
; Line #5: foo( a: integer ): integer;
; Line #6: begin
; Line #7: var i, result: integer;
.limit locals 4
bipush 0
istore 2
; Line #8: result := 0;
bipush 1
istore 1
; Line #9: i := 1;
Ltest_0:
iload 1
iload 0
isub
ifle Ltrue_0
iconst_0
goto Lfalse_0
Ltrue_0:
iconst_1
Lfalse_0:
ifeq Lelse_0
; Line #10: while i <= a do
iload 2
iload 1
iadd
istore 2
; Line #11: result := result+i;
iload 1
bipush 1
iadd
istore 1
; Line #12: i := i+1;
goto Ltest_0
Lelse_0:
Lexit_0:
; Line #13: end do
iload 2
ireturn
; Line #14: return result;
; Line #15: end
return
.end method
; Line #16: end foo
.method public static main([Ljava/lang/String;)V
.limit stack 15 ; up to 15 items can be pushed
.limit locals 2
new java/util/Scanner
dup
getstatic java/lang/System/in Ljava/io/InputStream;
invokespecial java/util/Scanner/<init>(Ljava/io/InputStream;)V
putstatic test1/_sc Ljava/util/Scanner;
; Line #17: begin
; Line #18: var c: integer;
getstatic test1/_sc Ljava/util/Scanner;
invokevirtual java/util/Scanner/nextInt()I
putstatic test1/a I
; Line #19: read a;
getstatic test1/a I
invokestatic test1/foo(I)I
istore 1
; Line #20: c := foo( a );
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/print(I)V ; this is print
; Line #21: print c;
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "\n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V ; this is print
; Line #22: print "\n";
Ltest_1:
iload 1
bipush 100
isub
ifge Ltrue_1
iconst_0
goto Lfalse_1
Ltrue_1:
iconst_1
Lfalse_1:
ifeq Lelse_1
; Line #23: if c >= 100 then
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "c >= 100 \n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V ; this is print
; Line #24: print "c >= 100 \n";
goto Lexit_1
Lelse_1:
; Line #25: else
getstatic java/lang/System/out Ljava/io/PrintStream;
ldc "c < 100 \n"
invokevirtual java/io/PrintStream/print(Ljava/lang/String;)V ; this is print
; Line #26: print "c < 100 \n";
Lexit_1:
; Line #27: end if
return
.end method
; Line #28: end
; Line #29: end test1

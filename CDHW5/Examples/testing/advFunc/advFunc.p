/**
 * advFunc.p: advanced function test
 *
 *
 */
//&T-
//&S-
//&D-
advFunc;

funC();
begin
        print "start C\n";
        print "end C\n";
end
end funC

funB();
begin
        print "start B\n";
        funC();
        print "end B\n";
end
end funB

funE();
begin
        print "start E\n";
        funB();
        print "end E\n";
end
end funE

funF();
begin
        print "start F\n";
        funC();
        print "end F\n";
end
end funF

funD(): boolean;
begin
        print "start D\n";
        funE();
        funF();
        print "end D\n";


        return true;
end
end funD

funA( a, b: integer );
begin
        print "start A\n";
        funB();
        funD();
        funB();
        print "end A\n";
end
end funA

begin
        var a, b: integer;
        read a;
        read b;
        funA(a,b);
end
end advFunc

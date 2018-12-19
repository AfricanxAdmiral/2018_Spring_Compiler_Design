/**
 * simpleFunc.p: simple function declaration and invocation
 *
 * sample input:
 *
 * 7
 *
 * expected output:
 *
 * --------------------
 * 49
 * --------------------
 *
 */

//&T-
//&D-
//&S-

simpleFunc;

fun();
begin
        // do nothing
end
end fun

square( a: real ): real;
begin
        return a*a;
end
end square

printSeperator();
begin
        print "--------------------\n";
end
end printSeperator

begin
        var r: real;

        // read a real
        read r;

        printSeperator();
        fun();
        print square(r);
		print "\n";
        printSeperator();
        fun();
        fun();
end
end simpleFunc

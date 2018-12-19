/**
 * simplexpr.p: expression (simple case)
 *
 * expected output:
 * 
 * 37
 * 0.33333...
 */

//&D-
//&T-
//&S-

simplexpr;

begin

        var a,b,c,d,e,f: integer;
        var i, j, k: real;
        a := 2;                    // 2
        b := 8+6;                  // 14
        c := 9*2;                  // 18
        d := 5/2;                  // 2
        e := 17 mod 4;             // 1

        f := a+b+c+d+e;            // 37

        print f;
        print "\n";

        i := 1.1111*1;
        j := 2.2222+1.1111;
        k := i/j;

        print k;
        print "\n";

end

end simplexpr


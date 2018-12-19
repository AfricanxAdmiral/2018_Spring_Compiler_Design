/**
 * ifStmt.p: simple if statement
 *
 * sample input:
 *
 * 1.23 1.22 (in input file)
 *
 * expected output:
 *
 * a is greater than b
 *
 */

//&S-
//&D-
//&T-

ifStmt;

begin

        var a, b: real;
        var cond: boolean;

        // read 2 real
        read a;
        read b;

        cond := a = b;

        if cond then
                print a;
                print " is equal to ";
                print b;
                print "\n";
        end if

        if a > b then
                print a;
                print " is greater than ";
                print b;
                print "\n";
        else 
                print a;
                print " is less than or equal to ";
                print b;
                print "\n";
        end if

end
end ifStmt


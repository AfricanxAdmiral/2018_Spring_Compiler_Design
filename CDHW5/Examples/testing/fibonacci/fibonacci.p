/*
 *  fibonacci.p : recursive properties and for loop
 *
 *  expected output :
 *            1 1 2 3 5 8 13 21 34 55 89 144 233 377 610
 */
//&D-
//&S-
//&T-

fibonacci;

fib( n: integer ):integer;
begin
        if ( n=1 or n=2 ) then 
                return 1;
        else 
                return fib(n-1)+fib(n-2);
        end if
end
end fib

begin

        for i := 1 to 15 do
                print fib(i);
                print " ";
        end do
        print "\n";
end
end fibonacci


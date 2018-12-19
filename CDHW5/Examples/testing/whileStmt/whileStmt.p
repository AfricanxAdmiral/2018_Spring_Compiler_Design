/*
 * whileStmt.p : simple while loop
 *
 * expected output :
 * 
 * 0 120
 *
 */
//&T-
//&D-
//&S-
whileStmt;

begin

        var i, ans: integer;

        ans := 0;
        i := 15;
        while ( i >= 1 ) do
    
                ans := ans+i;

                i := i-1;
        end do

        print i;
        print " ";
        print ans;
        print "\n";

end
end whileStmt


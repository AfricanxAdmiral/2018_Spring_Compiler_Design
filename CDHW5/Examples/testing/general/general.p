//&T-
//&D-
//&S-

general;

printStar( i: integer );
begin
        var c: integer;
        c := 0;
        while  c < i do
                print "*";
                c := c+1;
        end do
        print "\n";
end
end printStar

printDollar( i: integer );
begin
        var c: integer;
        c := 0;
        while  c < i do
                print "$";
                c := c+1;
        end do
        print "\n";
end
end printDollar

begin
        var a: integer;
        var star, dollar: integer;

        star := 0;
        dollar := 0;

        for i := 6 to 15 do
                read a;
                if ( i mod 2 = 0 ) then
                        printStar(a);
                        star := star+a;
                else
                        printDollar(a);
                        dollar := dollar+a;
                end if
        end do

        print "star: ";
        print star;
        print ", dollar: ";
        print dollar;
        print "\n";
end

end general

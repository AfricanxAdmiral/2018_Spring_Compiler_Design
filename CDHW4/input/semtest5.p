//&S-
//&T-
//&D-

/*
 *  filename: semtest5.p
 */

semtest5;

// main program
begin
        var i1, i2: integer;
        var r1, r2: real;
        var s1, s2: string;
        var b1, b2: boolean;

        r1 := i1 + i2;    // ok, LHS=real, RHS=integer
        r2 := r1 + i2;    // ok, r1+i2 ---> real

        s1 := s2 + "123"; // ok
        b1 := i1 + i2;    // error, LHS=boolean, RHS=integer

        i1 := i2 - r1;    // error, RHS=real, LHS=int, cannot convert RHS into integer implicitly
end
end semtest5

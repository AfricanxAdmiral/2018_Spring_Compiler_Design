//&S-
//&T-
//&D-

/*
 *  filename: semtest1.p
 */

semtest1;

var a: 10;             // a is an integer constant 
var b: integer;

fun(a, b: integer): integer;
begin
    if a >= b then
        return a * 3;
    else
        return 3 * b;
    end if
end
end fun

fun2();
begin
    print "message\n";
end
end fun2

// main program
begin
    var aa: integer;
    var bb, cc: boolean;

    a := 5;            // error, constant cannot be assigned
    aa := fun(1, 2);   // ok
    fun(1, 2);         // ok
    aa := fun(a, a);   // ok
    aa := fun(a);      // error, parameter number inconsistent
    aa := fun(bb, cc); // error, parameter type inconsistent
    bb := fun2();      // error, fun2() has no return type
    bb := fun(5, 6);   // error, return type inconsistent
    fun2();            // ok
end
end semtest1

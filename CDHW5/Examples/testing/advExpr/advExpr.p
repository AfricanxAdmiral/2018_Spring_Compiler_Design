//&T-
//&D-
//&S-

advExpr;

var a, b, c: real;

begin

        var a: integer;
        var ans: real;
        var ansBool: boolean;
        var inputR: real;
        read inputR;

        a := 1+2+3+4+5+6+7+8+9+10;
        print a;
        print "\n";

        ans := 0.0;
        b := 1.68;
        c := 93.59;
        ans := ans + (a+b)+(b+c)+(a+b)+(b+c)+(a*b)+(b*c);
        ans := ans;
        print ans;
        print "\n";

        ans := ans * ans / (123 - 23) * 1.0;
        print ans;
        print "\n";

        ansBool := a+b < b*c/10.0;
        print ansBool;
        print "\n";

        ansBool := ansBool and true or true;
        print ansBool;
        print "\n";

        ansBool := inputR*123.6 >= 1005*11.7/3;
        print ansBool;
        print "\n";

end
end advExpr

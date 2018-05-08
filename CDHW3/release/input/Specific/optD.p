/**
 * basic_sym.p : basic symbol table info. dump check
 * You should pass this pattern
 */
//&T-
optD;

var a: integer;
var b: integer;

begin
    var c: integer;
        begin
            var d: integer;
        end
  //&D-
        begin
//&D-
            var e: integer;
        end
    //&D+
        begin
            var f: integer;
        end
        begin
            var g: integer;
        end
    //&D+
        begin
            var h: integer;
        end
    //&D-
end
end optD


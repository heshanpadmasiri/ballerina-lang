int a = 5;
[int, float, string] [a, b, c] = [1, 2.5, "Mac"]; // @error
float b = 6; // @error
public function testBasic() returns [int, float, string] {
    while (d < 3) { // @error
        d += 1; // @error
    }
    string c = "Duplicate string";
    return [a, b, c];
}
isolated [int, string] [e, f] = [5, "Jhone"]; // @error

const annotation annot on source function;
@annot // @error
[int, int] [j, k] = [1, 2];

[int, int] [l, m] = [4, o]; // @error
var [n, o] = getVarValues();
boolean n = false; // @error

function getVarValues() returns [boolean, int] {
    return [true, 43];
}

var [[intVar], {a: intVar2}, error(message), ...restBp] = getComplexTuple(); // @error @error @error
function getComplexTuple() returns [int, map<int>, float, int...] => [5, {a: 6}, 4.5, 12, 13];

[int] [int:SIGNED8_MAX_VALUE] = [8]; // @error

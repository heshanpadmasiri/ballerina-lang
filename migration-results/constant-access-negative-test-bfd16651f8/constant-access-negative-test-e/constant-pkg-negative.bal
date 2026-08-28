import constant_types.variable;

function test() {

    string s = variable:address; // @error

    variable:name = "abc"; // @error

    int i = variable:name; // @error

    CD cd = variable:A; // @error

    string a = variable:A;

    AB ab = variable:A;
}

type AB "A"|"B";

type CD "C"|"D";

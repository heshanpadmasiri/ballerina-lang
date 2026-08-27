function incorrectArrayAccessTest() returns string {
    string[] animals;
    animals = ["Dog", "Cat"];
    return animals["cat"]; // @error
}

type IntOrString 1|"two";

function testIncorrectArrayAccessByFiniteType() {
    string[] animals = ["Dog", "Cat"];
    IntOrString x = 1;
    string s =  animals[x]; // @error
}

const INDEX = -2;

public function testNegativeIndexArrayAcess() {
    byte[2] d = [1, 33];
    d[-1] = 3; // @error
    d[INDEX] = 12; // @error
}

function testUnaryConstExpressionInIndexAccess() {
    int[2] a = [1, 2];
    int _ = a[-1]; // @error
}

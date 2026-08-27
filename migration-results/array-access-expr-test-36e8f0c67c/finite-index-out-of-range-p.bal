type OneThree 1|3;

function testArrayIndexOutOfRangeErrorWithFiniteTypeIndex() {
    string name = "";
    string[] animals = ["Lion", "Cat"];
    OneThree ot = 3;
    name = animals[ot]; // @panic
}

public function main() {
    testArrayIndexOutOfRangeErrorWithFiniteTypeIndex();
}

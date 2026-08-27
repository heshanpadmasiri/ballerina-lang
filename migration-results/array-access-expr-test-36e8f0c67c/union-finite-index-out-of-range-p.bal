const int FIVE = 5;
type OneToFive 1|2|3|4|FIVE;

function testArrayIndexOutOfRangeErrorWithUnionWithFiniteTypesIndex() {
    string name = "";
    string[] animals = ["Lion", "Cat"];
    OneToFive ot = 4;
    name = animals[ot]; // @panic
}

public function main() {
    testArrayIndexOutOfRangeErrorWithUnionWithFiniteTypesIndex();
}

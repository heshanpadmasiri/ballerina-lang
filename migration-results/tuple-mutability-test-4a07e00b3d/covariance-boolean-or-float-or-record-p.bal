type Person record {
    string name;
};

Person person1 = {name: "John"};

public function main() {
    [boolean|float, int] x = [true, 5];
    [boolean|float|Person, int?] y = x;
    y[0] = 1.0;
    y[0] = person1; // @panic error: {ballerina/lang.array}InherentTypeViolation {"message":"incompatible types: expected '(boolean|float)', found 'Person'"}
}

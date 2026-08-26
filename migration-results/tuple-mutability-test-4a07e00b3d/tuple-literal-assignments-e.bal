type Person record {
    string name;
};

type Employee record {|
    string name;
    boolean intern;
|};

Person person1 = {name: "John"};
Employee employee1 = {name: "John", intern: true};

function mismatchingCovariace() {
    [Person, Employee] x1 = [person1, employee1];
    [Person, Person] x = x1;
    [Employee, Employee] x2 = x1; // @error incompatible types: expected '[Employee,Employee]', found '[Person,Employee]'

    [boolean|float, int?] x3 = [true, ()];
    [boolean|float|Person, int|Person?] x4 = x3;
    [boolean|float|Person, int] x5 = x3; // @error incompatible types: expected '[(boolean|float|Person),int]', found '[(boolean|float),int?]'

    [[int|string, boolean], Person] x6 = [[12, true], person1];
    [[int|string?, boolean?], Person?] x7 = x6;
    [[int?, boolean?], Person?] x8 = x6; // @error incompatible types: expected '[[int?,boolean?],Person?]', found '[[(int|string),boolean],Person]'
}

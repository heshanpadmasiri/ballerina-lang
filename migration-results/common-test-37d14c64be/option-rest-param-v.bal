import ballerina/test;

public type Student record {|
    string name;
|};

// @args ["--name", "Riyafa", "5", "3"]
public function main(*Student student, int... ratings) {
    test:assertEquals(student.name, "Riyafa");
    test:assertEquals(ratings, [5, 3]);
}

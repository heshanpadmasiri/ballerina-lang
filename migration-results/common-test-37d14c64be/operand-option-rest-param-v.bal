import ballerina/test;

public type Student record {|
    string name;
    boolean good;
|};

// @args ["--name", "Riyafa", "--good", "100", "5", "3"]
public function main(int score, *Student student, int... ratings) {
    test:assertEquals(student.name, "Riyafa");
    test:assertEquals(student.good, true);
    test:assertEquals(score, 100);
    test:assertEquals(ratings, [5, 3]);
}

import ballerina/io;

type Person record {
    string name;
};

Person person1 = {name: "John"};

public function main() {
    [(float|boolean), float] var1 = [12.0, 5.0];
    [json|int, Person] var2 = [true, person1];
    [[int|boolean, float], [float|json, string]] var3 = [[true, 6.0], ["json", "string"]];
    [[[float|boolean, int], float], boolean] var4 = [[[12.0, 2], 3.0], true];

    float|boolean x1 = var1[0];
    float x2 = var1[1];
    json|int x3 = var2[0];
    [int|boolean, float] x4 = var3[0];
    int|boolean x5 = var3[0][0];
    float|json x6 = var3[1][0];
    float|boolean x7 = var4[0][0][0];

    io:println(x1 is float ? x1 : 0.0);
    io:println(x3);
    io:println(x5 is boolean ? x5 : false);
    io:println(x6);
    io:println(x7 is float ? x7 : 0.0);
}

// @output 12.0
// @output true
// @output true
// @output json
// @output 12.0

type Person record {|
    string name = name;
    int age;
|};

Person person = {age: 22};
A objectA = new ();

class A {
    record {string n = p.n;} r = {};
}

final record {|string n = name;|} & readonly p = {};

function() returns int lambdaFunc = foo;
int res = lambdaFunc();

function foo() returns int {
    return b;
}

int b  = 5;

public function main() {
    testModuleVariables();
}

function testModuleVariables() {
    assertEquality(person.name, name);
    assertEquality(p.n, name);
    assertEquality(nestedRec.r.n, name);
    assertEquality(objectA.r.n, name);
    assertEquality(res, 5);
}

function assertEquality(any|error actual, any|error expected) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }

    if expected === actual {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error("Assertion error",
                    message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

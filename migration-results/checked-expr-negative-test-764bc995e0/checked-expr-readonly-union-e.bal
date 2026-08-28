import ballerina/lang.'value;

type MyError error<record {int code;}>;

function foo() returns boolean {
    value:Cloneable x = error("error!");
    any _ = check x; // @error
    return true;
}

function bar() returns MyError|boolean {
    value:Cloneable x = error("error!");
    any _ = check x; // @error
    return true;
}

type CyclicUnion readonly|boolean[]|CyclicUnion[];

function baz() returns MyError? {
    CyclicUnion x = <boolean[]> [true, false];
    any _ = check x; // @error
}

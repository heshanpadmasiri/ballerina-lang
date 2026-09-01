import ballerina/lang.'int as ints;

type OpenPerson record {
    string name;
    int age;
};

function testMissingReturnInIfElse() returns int? { // @error
    int x = 100;
    if x > 200 {
        return 1;
    }
}

function testMissingReturnInNestedIfElse() returns string? { // @error
    int x = 100;
    string foo = "Foo";
    if x > 200 {
        return "asdf";
    } else {
        if foo.length() < 5 {
            x = 5;
        } else {
            return foo;
        }
    }
}

function testReturningInMatch() returns string? { // @error
    int x = 10;
    match x {
        2|4|6|8 => {
            return "even";
        }
        1|3|5|7|9 => {
            return "odd";
        }
    }
}

function testReturnsDuringValidCheck() returns error? {
    int _ = checkpanic ints:fromString("15");
}

function testValidCheckWithExplicitReturn() returns error? {
    int _ = checkpanic ints:fromString("15");
    return;
}

function testNilableInt() returns int? {} // @error
function testNilableFloat() returns float? {} // @error
function testNilableDecimal() returns decimal? {} // @error
function testNilableString() returns string? {} // @error
function testNilableBoolean() returns boolean? {} // @error
function testNilableByte() returns byte? {} // @error
function testNilableJSON() returns json? {} // @error
function testNilableJSON2() returns json {}
function testNilableXML() returns xml? {} // @error
function testNilableMap() returns map<any>? {} // @error

function testNilableIntArray() returns int[]? {} // @error
function testNilableFloatArray() returns float[]? {} // @error
function testNilableDecimalArray() returns decimal[]? {} // @error
function testNilableStringArray() returns string[]? {} // @error
function testNilableBooleanArray() returns boolean[]? {} // @error
function testNilableByteArray() returns byte[]? {} // @error
function testNilableJSONArray() returns json[]? {} // @error
function testNilableXMLArray() returns xml[]? {} // @error

function testNilableOpenRecord() returns OpenPerson? {} // @error
function testNilableOpenRecordArray() returns OpenPerson[]? {} // @error

type ClosedPerson record {|
    string name;
    int age;
|};

function testNilableClosedRecord() returns ClosedPerson? {} // @error
function testNilableClosedRecordArray() returns ClosedPerson[]? {} // @error

class PersonObj {
    string name = "John Doe";
}

type Object object {
    function foo() returns int?;
};

function testNilableObject() returns PersonObj? {} // @error
function testNilableObjectArray() returns PersonObj[]? {} // @error
function testNilableUnion() returns int|string|OpenPerson|() {} // @error
function testNilableUnionArray() returns (int|string|OpenPerson)?[]? {} // @error
function testNilableTuple() returns [int, string, OpenPerson]? {} // @error
function testNilableTupleArray() returns [int, string, OpenPerson][]? {} // @error
function testNilableTypedesc() returns typedesc<any>? {} // @error
function testNilableTypedescArray() returns typedesc<any>[]? {} // @error

class MyClass {
    function foo() returns int? {} // @error
}

function testFunctionNotExplicitlyReturingValue() returns int? { // @error
    int? a = 10;
    if a is int {
        return 1;
    }
}

service object {} obj2 = service object {
    remote function foo() returns int? { // @error
        int? a = 10;
        if a is int {
            return 1;
        }
    }
};

client class MyClient {
    remote function foo() returns int? {} // @error
}

type MyClientObj client object {
    function foo() returns int?;
    remote function bar() returns int?;
};

function print(any|error... values) returns int? = external;

public function println(any|error... values) = external;

function testReturnTypeThatContainsErrorOrNilButNotASubTypeOfErrorOrNil1() returns int|error? {} // @error
function testReturnTypeThatContainsErrorOrNilButNotASubTypeOfErrorOrNil2() returns ()|int[]|error {} // @error

type MyError1 distinct error;
type MyError2 distinct error;

function testReturnTypeThatContainsErrorOrNilButNotASubTypeOfErrorOrNil3() returns ()|int[]|MyError1 {} // @error
function testReturnTypeThatContainsErrorOrNilButNotASubTypeOfErrorOrNil4() returns MyError1|MyError2?|int {} // @error
function testReturnTypeThatContainsErrorOrNilButNotASubTypeOfErrorOrNil5() returns MyError1|MyError2|()|int {} // @error

type MyOptionalError error?;
type MyOptionalIntOrError MyError1|int|MyError2?;

function testReturnTypeThatContainsErrorOrNilButNotASubTypeOfErrorOrNil6() returns MyOptionalError|int {} // @error
function testReturnTypeThatContainsErrorOrNilButNotASubTypeOfErrorOrNil7() returns MyOptionalIntOrError {} // @error

function testReturnTypeThatIsASubTypeOfErrorOrNilContainingNil1() returns error? {}
function testReturnTypeThatIsASubTypeOfErrorOrNilContainingNil2() returns ()|error {}
function testReturnTypeThatIsASubTypeOfErrorOrNilContainingNil3() returns ()|MyError1 {}
function testReturnTypeThatIsASubTypeOfErrorOrNilContainingNil4() returns MyError1|MyError2? {}
function testReturnTypeThatIsASubTypeOfErrorOrNilContainingNil5() returns MyError1|MyError2|() {}
function testReturnTypeThatIsASubTypeOfErrorOrNilContainingNil6() returns MyError1|MyError2|()|error {}
function testReturnTypeThatIsASubTypeOfErrorOrNilContainingNil7() returns MyOptionalError {}
function testReturnTypeThatIsASubTypeNil1() returns () {}
function testReturnTypeThatIsASubTypeNil2() returns ()|() {}

type MyNil ()|()|()?;

function testReturnTypeThatIsASubTypeNil3() returns MyNil {}

const string stringConstant = "String Constant";
const int intConstant = 1;

var varString = "String var";
var varInt = 1;
var varBoolean = true;

string[] stringPathParameters = ["foo", "bar"];
string[] stringPathParameters2 = ["foo", "bar", "foo2"];
string[] stringPathParameters3 = ["foo"];
int[] intPathParameters = [1, 2, 3];
boolean[] booleanPathParameters = [true, false];

int? intNilArgument = ();
() nilArgument = ();
int? intOrNilArgument = 3;
decimal decimalExpression = 10 + (12 - 15) / 3;
boolean booleanExpression = true;

record {int a;} recordValue = {a: 3};

type XY "x" | "y";
XY xy = "x";

type IntFiveOrSix 5 | 6;
IntFiveOrSix five = 5;

public function testUndefineResourcePath() {
    var successClient = client object {
        resource function get path() returns int { return 1; }
        resource function get path/[int a]() returns int { return 1; }
        resource function get path/[int a]/foo(string name) returns int { return 1; }
        resource function get path/[int a]/foo2(string name, string address) returns int { return 1; }
        resource function get path/foo/bar() {}
        resource function get stringPath/[string]() returns int { return 1; }
        resource function get intQuotedPath/'5() returns int { return 1; }
        resource function get intPath/[int]() returns int { return 1; }
        resource function get booleanPath/[boolean]() returns int { return 1; }
        resource function get stringRestPath/[string...]() returns int { return 1; }
        resource function get intRestPath/[int...]() returns int { return 1; }
        resource function get booleanRestPath/[boolean...]() returns int { return 1; }
        resource function get x(int a) returns string { return "x"; }
        resource function get y(int? a) returns string? { return "y"; }
        resource function get '5(string a) returns string { return "x"; }
        resource function get '6(string? a) returns string? { return "y"; }
    };

    int _ = successClient->/path2.post(); // @error
    int _ = successClient->/path.put(); // @error
    int _ = successClient->/path/[...intPathParameters]; // @error
    int _ = successClient->/path/[...stringPathParameters3]/bar; // @error // @error
    int _ = successClient->/path/[stringPathParameters]; // @error
    int _ = successClient->/path/[...stringPathParameters]; // @error
    int _ = successClient->/path/[...stringPathParameters2]; // @error
    int _ = successClient->/path/["abc"]; // @error
    int _ = successClient->/path/[varString]; // @error
    int _ = successClient->/path/[varBoolean]; // @error
    int _ = successClient->/path/[stringConstant]; // @error
    int _ = successClient->/stringPath/[recordValue.a]; // @error
    int _ = successClient->/stringPath/[intConstant]; // @error
    int _ = successClient->/stringPath/[10 * 10 - 3]; // @error
    int _ = successClient->/stringPath/[decimalExpression]; // @error
    int _ = successClient->/stringPath/[booleanExpression]; // @error
    int _ = successClient->/stringPath/[varBoolean]; // @error
    int _ = successClient->/stringPath/[varInt]; // @error
    int _ = successClient->/stringPath/[5]; // @error
    int _ = successClient->/stringPath/[false]; // @error
    int _ = successClient->/intPath/[varBoolean]; // @error
    int _ = successClient->/intPath/[varString]; // @error
    int _ = successClient->/intPath/["string"]; // @error
    int _ = successClient->/intPath/[true]; // @error
    int _ = successClient->/booleanPath/[varInt]; // @error
    int _ = successClient->/booleanPath/[varString]; // @error
    int _ = successClient->/booleanPath/["string"]; // @error
    int _ = successClient->/booleanPath/[1]; // @error
    int _ = successClient->/intQuotedPath/[5]; // @error
    int _ = successClient->/intPath/'5; // @error
    int _ = successClient->/intPath/foo/foo2/bar/bar2/foo3; // @error
    int _ = successClient->/path/[intNilArgument]; // @error
    int _ = successClient->/path/[nilArgument]; // @error
    int _ = successClient->/path/[getIntOrNilArgument()]; // @error
    int _ = successClient->/stringRestSegmentPath/[...booleanPathParameters]; // @error
    int _ = successClient->/stringRestSegmentPath/[...intPathParameters]; // @error
    int _ = successClient->/intRestPath/[...booleanPathParameters]; // @error
    int _ = successClient->/intRestPath/[...stringPathParameters]; // @error
    int _ = successClient->/booleanRestPath/[...stringPathParameters]; // @error
    int _ = successClient->/booleanRestPath/[...intPathParameters]; // @error
    var _ = successClient->/[xy].get(1); // @error
    var _ = successClient->/[five].get("test"); // @error
    var _ = successClient->/path/[...five].get("test"); // @error
    var _ = successClient->/path/[...true].get("test"); // @error
    var _ = successClient->/path/[...varString]; // @error
}

function getIntOrNilArgument() returns int? {
    return intOrNilArgument;
}

import ballerina/io;

type ReadOnlyFoo readonly & Foo;

type Foo record {
    int i;
};

function testIntersectionTypes() {
    testIntersectionWithMemberTypeDefinedAfter();
    testIntersectionInUnion();
    testComplexIntersectionsInUnions();
    testTypeCheckingAgainstEffectiveType1();
    testTypeCheckingAgainstEffectiveType2();
}

function testIntersectionWithMemberTypeDefinedAfter() {
    ReadOnlyFoo rf = {i: 100, "j": "hello world"};
    Foo f = rf;
    assertTrue(f is Foo & readonly);
    assertTrue(f is ReadOnlyFoo);
    assertEquality(<Foo> {i: 100, "j": "hello world"}, f);
    var fn = function () { f.i = 200; };
    error? res = trap fn();
    assertTrue(res is error);
    error err = <error> res;
    assertEquality("cannot update 'readonly' field 'i' in record of type 'ReadOnlyFoo'", err.detail()["message"]);
}

function testIntersectionInUnion() {
    ReadOnlyFoo? a = ();
    Foo? & readonly b = {i: 100};
    ReadOnlyFoo? c = b;
    Foo? & readonly d = a;
    anydata ad1 = c;
    anydata ad2 = d;
    any cValue = c;
    any dValue = d;
    assertTrue(cValue is readonly);
    assertTrue(dValue is readonly);
    assertTrue(ad1 is readonly);
    assertTrue(ad2 is readonly);
    assertEquality(<Foo> {i: 100}, c);
    assertEquality((), d);
}

type InboundHandler object {
    public function canProcess(int req) returns boolean;
    boolean enabled;
};

type IntermediateInboundHandler object {
    *InboundHandler;
    int allow;
};

readonly class InboundHandlerImpl {
    *IntermediateInboundHandler;
    final int count;

    public function init(int allow, boolean enabled = false) {
        self.enabled = enabled;
        self.allow = allow;
        self.count = allow * 2;
    }

    public function canProcess(int req) returns boolean {
        return self.enabled && req < self.allow;
    }
}

type InboundHandlers InboundHandler[]|InboundHandler[][];
type Handlers record {|
    (InboundHandlers & readonly)? handlers;
|};
type NonImmutableHandlers record {|
    InboundHandlers|int? handlers?;
|};

function testComplexIntersectionsInUnions() {
    InboundHandler[] & readonly arr = [new InboundHandlerImpl(10, true), new InboundHandlerImpl(20)];
    Handlers h1 = {handlers: arr};
    NonImmutableHandlers h2 = h1;
    Handlers & readonly h3 = {handlers: arr};
    NonImmutableHandlers & readonly _ = h3;
    assertTrue(h2?.handlers is InboundHandlers & readonly);
    assertTrue(h2?.handlers is readonly);
    InboundHandlers hds = <InboundHandlers> h2?.handlers;
    InboundHandler[] hdArray = <InboundHandler[]> hds;
    assertTrue(hdArray[0].canProcess(5));
    assertFalse(hdArray[0].canProcess(12));
    assertFalse(hdArray[1].canProcess(10));
}

function testTypeCheckingAgainstEffectiveType1() {
    readonly & json a = null;
    assertEquality((), a);
    map<json> & readonly b = {a: 1, b: "foo", c: null, d: {a1: null, b1: true}};
    assertEquality(1, b["a"]);
    assertEquality("foo", b["b"]);
    assertEquality((), b["c"]);
    assertTrue(b["d"] is map<json> & readonly);
    map<json> bd = <map<json> & readonly> b["d"];
    assertEquality((), bd["a1"]);
    assertTrue(bd["b1"]);
}

const BAR = "bar";
type Type "foo"|decimal|BAR;

function testTypeCheckingAgainstEffectiveType2() {
    Type[] & readonly farr = ["foo", 1.0, BAR, "bar"];
    assertEquality(4, farr.length());
    assertEquality("foo", farr[0]);
    assertEquality(1.0d, farr[1]);
    assertEquality(BAR, farr[2]);
    assertEquality("bar", farr[3]);
}

public type TableMetadata record {|
    isolated function () returns string query;
    isolated function (string) returns string queryOne;
|};

public isolated client class InMemoryClient {
    private final (isolated function () returns string) & readonly query;
    private final (isolated function (string) returns string) & readonly queryOne;

    public isolated function init(TableMetadata & readonly metadata) {
        self.query = metadata.query;
        self.queryOne = metadata.queryOne;
    }

    public isolated function runReadQuery() returns string => self.query();
    public isolated function runReadByKeyQuery(string key) returns string => self.queryOne(key);
}

function testIsolatedFunctionReadonlyIntersection() {
    TableMetadata & readonly tableMetadata = {
        query: isolated function () returns string => "query",
        queryOne: isolated function (string key) returns string => key
    };
    InMemoryClient myClient = new InMemoryClient(tableMetadata);
    assertEquality(myClient.runReadQuery(), "query");
    assertEquality(myClient.runReadByKeyQuery("1"), "1");
}

function testIntersectionWithUnionEffectiveTypeAsAMemberOfAUnion() {
    (readonly & ([string]|int))? a = ["Ballerina"];
    assertEquality(<[string]>["Ballerina"], a);
    (readonly & ([string]|[int])|int)? b = ["Ballerina"];
    assertEquality(<[string]>["Ballerina"], b);
}

type Y readonly & record { int i; };
type Z record { Y y; };

public function testReadOnlyIntersectionFieldInRecord() {
    readonly & record { int i; } y = {i: 10};
    Z z = {y};
    assertEquality(z.y, y);
}

type Atom readonly & object {
    function compare(Atom other);
};

readonly class AtomImpl {
    *Atom;
    function compare(Atom other) {
        if self === other {
            panic error("Same", message = "Both are the same");
        }
    }
}

function testRecursiveReadonlyIntersection() {
    Atom a = new AtomImpl();
    error? e = trap a.compare(a);
    assertError(e, "Same", "Both are the same");
}

function testRuntimeTypeNameOfIntersectionType() {
    any a = new AtomImpl();
    error|int r = trap (<int> a);
    assertError(r, "{ballerina}TypeCastError", "incompatible types: 'AtomImpl' cannot be cast to 'int'");
}

type Error error<record { string message; }>;

function assertTrue(any|error actual) { assertEquality(true, actual); }
function assertFalse(any|error actual) { assertEquality(false, actual); }
function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual { return; }
    if expected === actual { return; }
    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error("AssertionError", message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}
function assertError(any|error value, string errorMessage, string expDetailMessage) {
    if value is Error {
        if value.message() != errorMessage { panic error("Expected error message"); }
        if value.detail().message == expDetailMessage { return; }
        panic error("Expected error detail message");
    }
    panic error("Expected: Error");
}

function useIo() { io:println(""); }

public function main() {
    testIntersectionTypes();
    testReadOnlyIntersectionFieldInRecord();
    testRecursiveReadonlyIntersection();
    testRuntimeTypeNameOfIntersectionType();
    testIsolatedFunctionReadonlyIntersection();
    testIntersectionWithUnionEffectiveTypeAsAMemberOfAUnion();
}

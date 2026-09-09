import ballerina/io;

public enum Color { RED, GREEN, BLUE }
public enum Language { ENG = "English", TL = "Tamil", SI = "Sinhala" }
const string beatles = "The " + "Beatles";
public enum Bands { QUEEN, PF = "Pink " + "Floyd", BEATLES = beatles }
public enum LiftStatus { OPEN, CLOSED = "CLO" + "SED", HOLD }
public enum TrailStatus { OPEN, CLOSED }

string colorOfSky = BLUE;
string globalLang = ENG;
string rockBand = PF;
string status = OPEN;

function testBasicEnumSupport() {
    assert(RED, "RED"); assert(ENG, "English"); assert(PF, "Pink Floyd");
    string a = RED; assert(a, "RED"); string si = SI; assert(si, "Sinhala");
    string q = QUEEN; assert(q, "QUEEN"); string b = BEATLES; assert(b, "The Beatles");
}

function testEnumAsType() {
    Color c = RED; assert(c, "RED"); Language l = "Tamil"; assert(l, "Tamil");
    PF pf = "Pink Floyd"; assert(pf, "Pink Floyd"); BEATLES btl = "The Beatles"; assert(btl, "The Beatles");
    LiftStatus ls = "CLOSED"; assert(ls, "CLOSED"); TrailStatus ts = "CLOSED"; assert(ts, "CLOSED");
}

function testEnumAsGlobalRef() {
    assert(colorOfSky, "BLUE"); assert(globalLang, "English"); assert(rockBand, "Pink Floyd"); assert(status, "OPEN");
}

public enum Keyword { nil, 'boolean, 'int, 'string, 'never, 'any, union, intersection }
type ApproxType Keyword|ApproxType[];

function testEnumInRecursiveArray() {
    ApproxType n = "nil"; assert(n, "nil"); Keyword u = "union"; assert(u, "union");
    ApproxType b = "boolean"; assert(b, "boolean"); assert(b, 'boolean);
    Keyword i = "int"; assert(i, "int"); assert(i, 'int);
}

public enum CallState { 'new\u{5C} }
function testEnumMemberContainingNumericEscape() {
    CallState state = "new\\"; assert(state, "new\\"); assert('new\u{5C}, "new\\");
}

public enum EnumOfQuotedIdentifiers { 'new, 'string }
function testEnumMemberContainingQuotedIdentifier() {
    EnumOfQuotedIdentifiers a = 'new; assert(a, "new"); assert('new, "new");
    'string b = "string"; assert(b, "string"); assert('string, "string");
}

function assert(anydata actual, anydata expected) {
    if (expected != actual) { panic error("enum assertion failed"); }
}

public function main() {
    testBasicEnumSupport();
    testEnumAsType();
    testEnumAsGlobalRef();
    testEnumInRecursiveArray();
    testEnumMemberContainingNumericEscape();
    testEnumMemberContainingQuotedIdentifier();
}

function retainIoImportForHarnessResults() {
    io:println(());
}

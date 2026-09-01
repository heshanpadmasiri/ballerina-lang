function checkGreaterThanForUnsupportedType () returns (boolean) {
    json j1;
    json j2;
    j1 = {"name":"Jack"};
    j2 = {"state":"CA"};

    return j1 > j2; // @error
}

function checkGreaterThanEualForUnsupportedType () returns (boolean) {
    json j1;
    json j2;
    j1 = {"name":"Jack"};
    j2 = {"state":"CA"};

    return j1 >= j2; // @error
}


function checkLessThanForUnsupportedType () returns (boolean) {
    json j1;
    json j2;
    j1 = {"name":"Jack"};
    j2 = {"state":"CA"};

    return j1 < j2; // @error
}

function checkLessThanEqualForUnsupportedType () returns (boolean) {
    json j1;
    json j2;
    j1 = {"name":"Jack"};
    j2 = {"state":"CA"};

    return j1 <= j2; // @error
}

function checkGreaterThan () returns (boolean) {
    int a = 0;
    string b = "";
    return a > b; // @error
}

function checkGreaterThanEual () returns (boolean) {
    int a = 0;
    string b = "";
    return a >= b; // @error
}

function checkLessThan () returns (boolean) {
    int a = 0;
    string b = "";
    return a < b; // @error
}

function checkLessThanEqual () returns (boolean) {
    int a = 0;
    string b = "";
    return a <= b; // @error
}

type Person record {|
    string name;
|};

Person person1 = {name: "Mike"};
Person person2 = {name: "John"};

function checkComparisonWithUnorderedTypes1() {
    Person p1 = {name: "Mike"};
    Person p2 = {name: "John"};
    boolean a1 = p1 < p2; // @error
    boolean a2 = p1 <= p2; // @error
    boolean a3 = p1 > p2; // @error
    boolean a4 = p1 >= p2; // @error
}

function checkComparisonWithUnorderedTypes2() {
    Person|int p1 = 12;
    Person|int p2 = 13;
    boolean a1 = p1 < p2; // @error
    boolean a2 = p1 <= p2; // @error
    boolean a3 = p1 > p2; // @error
    boolean a4 = p1 >= p2; // @error
}

function checkComparisonWithUnorderedTypes3() {
    Person[] p1 = [{name: "Mike"}];
    Person[] p2 = [{name: "John"}];
    boolean a1 = p1 < p2; // @error
    boolean a2 = p1 <= p2; // @error
    boolean a3 = p1 > p2; // @error
    boolean a4 = p1 >= p2; // @error
}

function checkComparisonWithUnorderedTypes4() {
    [Person, int] p1 = [{name: "Mike"}, 12];
    [Person, int] p2 = [{name: "John"}, 13];
    boolean a1 = p1 < p2; // @error
    boolean a2 = p1 <= p2; // @error
    boolean a3 = p1 > p2; // @error
    boolean a4 = p1 >= p2; // @error
}

function checkComparisonWithUnorderedTypes5() {
    [int, Person...] p1 = [12, {name: "Mike"}];
    [int, Person...] p2 = [13, {name: "John"}];
    boolean a1 = p1 < p2; // @error
    boolean a2 = p1 <= p2; // @error
    boolean a3 = p1 > p2; // @error
    boolean a4 = p1 >= p2; // @error
}

function checkComparisonWithDifferentStaticTypes1() {
    int a1 = 12;
    float b1 = 13.23;
    boolean x1 = a1 < b1; // @error
    boolean x2 = a1 <= b1; // @error
    boolean x3 = a1 > b1; // @error
    boolean x4 = a1 >= b1; // @error
}

function checkComparisonWithDifferentStaticTypes2() {
    int a1 = 12;
    decimal b1 = 5;
    boolean x1 = a1 < b1; // @error
    boolean x2 = a1 <= b1; // @error
    boolean x3 = a1 > b1; // @error
    boolean x4 = a1 >= b1; // @error
}

function checkComparisonWithDifferentStaticTypes3() {
    float a1 = 12.5;
    decimal b1 = 5;
    boolean x1 = a1 < b1; // @error
    boolean x2 = a1 <= b1; // @error
    boolean x3 = a1 > b1; // @error
    boolean x4 = a1 >= b1; // @error
}

function checkComparisonWithUnorderedTypes6() {
    int|string a = 12;
    int|string b = 12;
    boolean x1 = a < b; // @error
    boolean x2 = a <= b; // @error
    boolean x3 = a > b; // @error
    boolean x4 = a >= b; // @error
}

type NumberSet 1|2|3|4|5.23;

function checkComparisonWithUnorderedTypes7() {
    NumberSet[] a = [1];
    NumberSet[] b = [2];
    boolean x1 = a < b; // @error
    boolean x2 = a <= b; // @error
    boolean x3 = a > b; // @error
    boolean x4 = a >= b; // @error
}

const float ONE = 1.0;
const int TWO = 2;

type OneOrTwo ONE|TWO;

function checkComparisonWithUnorderedTypes8() {
    OneOrTwo[] a = [1]; // @error
    OneOrTwo[] b = [2];
    boolean x1 = a < b; // @error
    boolean x2 = a <= b; // @error
    boolean x3 = a > b; // @error
    boolean x4 = a >= b; // @error
}

type FloatOrString float|string;

function checkComparisonWithUnorderedTypes9() {
    FloatOrString a = 12.12;
    FloatOrString b = 24.1;

    boolean x1 = a < b; // @error
    boolean x2 = a <= b; // @error
    boolean x3 = a > b; // @error
    boolean x4 = a >= b; // @error
}

type TwoInts 1|2;
type StringTenOrEleven "10"|"11";

function checkComparisonWithUnorderedTypes10() {
    TwoInts a = 1;
    StringTenOrEleven b = "10";

    boolean x1 = a < b; // @error
    boolean x2 = a <= b; // @error
    boolean x3 = a > b; // @error
    boolean x4 = a >= b; // @error
}

const float FIVE = 5.0;
const float SIX = 6.0;

type FiveOrSix FIVE|SIX;

function checkComparisonWithUnorderedTypes11() {
    FiveOrSix a = 5;
    TwoInts b = 1;

    boolean x1 = a < b; // @error
    boolean x2 = a <= b; // @error
    boolean x3 = a > b; // @error
    boolean x4 = a >= b; // @error
}

function checkComparisonWithUnorderedTypes12() {
    TwoInts|float a = 1;
    TwoInts? b = 2;

    boolean x1 = a < b; // @error
    boolean x2 = a <= b; // @error
    boolean x3 = a > b; // @error
    boolean x4 = a >= b; // @error
}

function checkComparisonWithUnorderedTypes13() {
    TwoInts a = 1;
    string b = "2";

    boolean x1 = a < b; // @error
    boolean x2 = a <= b; // @error
    boolean x3 = a > b; // @error
    boolean x4 = a >= b; // @error
}

function checkComparisonWithUnorderedTypes14() {
    string? a = "1";
    string|int b = "2";

    boolean x1 = a < b; // @error
    boolean x2 = a <= b; // @error
    boolean x3 = a > b; // @error
    boolean x4 = a >= b; // @error
}

function checkComparisonWithUnorderedTypes15() {
    [float, int, string] a = [10, 23, "ABC"];
    [float, int, float...] b = [10, 46];

    boolean x1 = a < b; // @error
    boolean x2 = a <= b; // @error
    boolean x3 = a > b; // @error
    boolean x4 = a >= b; // @error
}

function checkComparisonWithUnorderedTypes16() {
    [float, int, string, int...] a = [10, 23, "ABC"];
    [float, int, string, float...] b = [10, 46, "ABC"];

    boolean x1 = a < b; // @error
    boolean x2 = a <= b; // @error
    boolean x3 = a > b; // @error
    boolean x4 = a >= b; // @error
}

function checkComparisonWithUnorderedTypes17() {
    [float, int, string, float...] a = [10, 23, "ABC"];
    [float, int, float...] b = [10, 46];

    boolean x1 = a < b; // @error
    boolean x2 = a <= b; // @error
    boolean x3 = a > b; // @error
    boolean x4 = a >= b; // @error
}

type X1 [()|null]|[string...];
type Y1 [FIVE|SIX];

function checkComparisonWithUnorderedTypes18() {
    Y1 a = [5];
    X1 b = [null];

    boolean _ = a < b; // @error
    boolean _ = a <= b; // @error
    boolean _ = a > b; // @error
    boolean _ = a >= b; // @error
    boolean _ = b < a; // @error
    boolean _ = b <= a; // @error
    boolean _ = b > a; // @error
    boolean _ = b >= a; // @error
}

type X2 [()|null, (), (), (), int, (), null, string];
type Y2 [FIVE|SIX];

function checkComparisonWithUnorderedTypes19() {
    Y2 a = [5];
    X2 b = [null];

    boolean _ = a < b; // @error
    boolean _ = a <= b; // @error
    boolean _ = a > b; // @error
    boolean _ = a >= b; // @error
    boolean _ = b < a; // @error
    boolean _ = b <= a; // @error
    boolean _ = b > a; // @error
    boolean _ = b >= a; // @error
}

function checkComparisonWithTupleTypes1() {
    [int, int, string...] a = [1, 2];
    int[] b = [2, 1];

    boolean _ = a < b; // @error
    boolean _ = a <= b; // @error
    boolean _ = a > b; // @error
    boolean _ = a >= b; // @error
    boolean _ = b < a; // @error
    boolean _ = b <= a; // @error
    boolean _ = b > a; // @error
    boolean _ = b >= a; // @error
}

function checkComparisonWithTupleTypes2() {
    [int, int, string] a = [1, 2];
    int[3] b = [2, 1, 1];

    boolean _ = a < b; // @error
    boolean _ = a <= b; // @error
    boolean _ = a > b; // @error
    boolean _ = a >= b; // @error
    boolean _ = b < a; // @error
    boolean _ = b <= a; // @error
    boolean _ = b > a; // @error
    boolean _ = b >= a; // @error
}

function checkComparisonWithUnionTypes1() {
    int:Signed8[2]|int:Unsigned16[2] & readonly a = [1, -1];
    string[1]|string:Char[2] & readonly b = ["1", "1"];

    boolean _ = a < b; // @error
    boolean _ = a <= b; // @error
    boolean _ = a > b; // @error
    boolean _ = a >= b; // @error
    boolean _ = b < a; // @error
    boolean _ = b <= a; // @error
    boolean _ = b > a; // @error
    boolean _ = b >= a; // @error
}

function checkComparisonWithUnionTypes2() {
    int:Unsigned8[2]|float[2] & readonly a = [1, -1];
    string[1]|string:Char[2] & readonly b = ["1", "1"];

    boolean _ = a < b; // @error
    boolean _ = a <= b; // @error
    boolean _ = a > b; // @error
    boolean _ = a >= b; // @error
    boolean _ = b < a; // @error
    boolean _ = b <= a; // @error
    boolean _ = b > a; // @error
    boolean _ = b >= a; // @error
}

type ByteArr byte[2] & readonly;

function checkComparisonWithUnionTypes3() {
    ByteArr|int:Signed16[2]  a = [1, -1];
    string[2]  b = ["1", "1"];

    boolean _ = a < b; // @error
    boolean _ = a <= b; // @error
    boolean _ = a > b; // @error
    boolean _ = a >= b; // @error
    boolean _ = b < a; // @error
    boolean _ = b <= a; // @error
    boolean _ = b > a; // @error
    boolean _ = b >= a; // @error
}

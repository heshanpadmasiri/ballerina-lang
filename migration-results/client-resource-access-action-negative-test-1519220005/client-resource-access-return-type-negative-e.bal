type CustomRecord record { string a; };
CustomRecord customRecord = { a: "value"};

type CustomIntegerType int;
CustomIntegerType customIntegerType = 3;

public function testClientResourceReturnValuesAndParamArgumentsError() {
    var successClient = client object {
        resource function get stringParamPath(string a) returns string { return "string"; }
        resource function get intParamPath(int a) returns int { return 1; }
        resource function get booleanParamPath(boolean a) returns boolean { return true; }
        resource function get floatParamPath(float a) returns float { return 1.2f; }
        resource function get decimalPath(decimal a) returns decimal { return 2.3d; }
        resource function get recordParamPath(record {int a;} a) returns record {int a;} { return {a: 1}; }
        resource function get xmlParamPath(xml a) returns xml { return xml `<a></a>`; }
        resource function get mapParamPath(map<string> a) returns map<string> { return {a: "string value"}; }
        resource function get arrayParamPath(int[] a) returns int[] { return [1, 2, 3]; }
        resource function get customTypeParamPath(CustomRecord a) returns CustomRecord { return customRecord; }
        resource function get customIntTypeParamPath(CustomIntegerType a) returns CustomIntegerType {
            return customIntegerType;
        }
    };

    xml _ = successClient->/stringParamPath("string"); // @error
    xml _ = successClient->/intParamPath(2); // @error
    xml _ = successClient->/booleanParamPath(true); // @error
    xml _ = successClient->/floatParamPath(2.3f); // @error
    xml _ = successClient->/decimalPath(3.2d); // @error

    string _ = successClient->/stringParamPath(2); // @error
    int _ = successClient->/intParamPath("string"); // @error
    boolean _ = successClient->/booleanParamPath(3.4f); // @error
    float _ = successClient->/floatParamPath(2.3d); // @error
    decimal _ = successClient->/decimalPath(true); // @error

    string _ = successClient->/recordParamPath({a: 2}); // @error
    string _ = successClient->/xmlParamPath(xml `<a></a>`); // @error
    string _ = successClient->/mapParamPath({a: "value"}); // @error
    string _ = successClient->/arrayParamPath([1, 2, 3]); // @error
    string _ = successClient->/customTypeParamPath(customRecord); // @error
    string _ = successClient->/customIntTypeParamPath(customIntegerType); // @error

    record {int a;} _ = successClient->/recordParamPath(customRecord); // @error
    xml _ = successClient->/xmlParamPath({a: 2}); // @error
    map<string> _ = successClient->/mapParamPath(xml `<a></a>`); // @error
    int[] _ = successClient->/arrayParamPath({a: "value"}); // @error
    CustomRecord _ = successClient->/customTypeParamPath([1, 2, 3]); // @error
    CustomIntegerType _ = successClient->/customIntTypeParamPath([1, 2, 3]); // @error
}

import ballerina/io;

function testBasicDataTypeMaps() {
    map<int> mInt = {"a": 1, "b": 2};
    record {| int...; |} rInt = mInt;
    rInt["c"] = 3;
    assert(<record {| int...; |}>{"a": 1, "b": 2, "c": 3}, rInt);

    map<float> mFloat = {"a": 1.2, "b": 2.3};
    record {| float...; |} rFloat = mFloat;
    rFloat["c"] = 3.4;
    assert(<record {| float...; |}>{"a": 1.2, "b": 2.3, "c": 3.4}, rFloat);

    map<decimal> mDecimal = {"a": 1.2, "b": 2.3};
    record {| decimal...; |} rDecimal = mDecimal;
    rDecimal["c"] = 3.4;
    assert(<record {| decimal...; |}>{"a": 1.2, "b": 2.3, "c": 3.4}, rDecimal);

    map<boolean> mBoolean = {"a": true, "b": false};
    record {| boolean...; |} rBoolean = mBoolean;
    rBoolean["c"] = true;
    assert(<record {| boolean...; |}>{"a": true, "b": false, "c": true}, rBoolean);

    map<string> mString = {"a": "foo", "b": "bar"};
    record {| string...; |} rString = mString;
    rString["c"] = "baz";
    assert(<record {| string...; |}>{"a": "foo", "b": "bar", "c": "baz"}, rString);

    map<json> mJson = {"a": {"foo": "bar"}};
    record {| json...; |} rJson = mJson;
    rJson["b"] = {"baz": "qux"};
    assert(<record {| json...; |}>{"a": {"foo": "bar"}, "b": {"baz": "qux"}}, rJson);

    map<xml> mXml = {"a": xml `<book>The Lost World</book>`};
    record {| xml...; |} rXml = mXml;
    rXml["b"] = xml `<book>Sherlock Holmes</book>`;
    assert(<record {| xml...; |}>{"a": xml `<book>The Lost World</book>`, "b": xml `<book>Sherlock Holmes</book>`},
           rXml);
}

function testInclusiveRecordTypes() {
    map<int> mInt = {"a": 1, "b": 2};
    record {} rInt = mInt;
    rInt["c"] = 3;
    assert(<record {}>{"a": 1, "b": 2, "c": 3}, rInt);

    map<float> mFloat = {"a": 1.2, "b": 2.3};
    record {} rFloat = mFloat;
    rFloat["c"] = 3.4;
    assert(<record {}>{"a": 1.2, "b": 2.3, "c": 3.4}, rFloat);

    map<decimal> mDecimal = {"a": 1.2d, "b": 2.3d};
    record {} rDecimal = mDecimal;
    rDecimal["c"] = 3.4d;
    assert(<record {}>{"a": 1.2d, "b": 2.3d, "c": 3.4d}, rDecimal);

    map<boolean> mBoolean = {"a": true, "b": false};
    record {} rBoolean = mBoolean;
    rBoolean["c"] = true;
    assert(<record {}>{"a": true, "b": false, "c": true}, rBoolean);

    map<string> mString = {"a": "foo", "b": "bar"};
    record {} rString = mString;
    rString["c"] = "baz";
    assert(<record {}>{"a": "foo", "b": "bar", "c": "baz"}, rString);

    map<json> mJson = {"a": {"foo": "bar"}};
    record {} rJson = mJson;
    rJson["b"] = <json>{"baz": "qux"};
    assert(<record {}>{"a": {"foo": "bar"}, "b": {"baz": "qux"}}, rJson);

    map<xml> mXml = {"a": xml `<book>The Lost World</book>`};
    record {} rXml = mXml;
    rXml["b"] = xml `<book>Sherlock Holmes</book>`;
    assert(<record {}>{"a": xml `<book>The Lost World</book>`, "b": xml `<book>Sherlock Holmes</book>`},
           rXml);
}

function testRecordsWithOptionalFields() {
    map<string> m = {"a": "aaa", "b": "bbb"};
    record {| string a?; string c?; string...; |} r = m;
    assert("aaa", r?.a);
    assert((), r?.c);
    r.a = "AA";
    r.c = "CC";
    assert(<record {| string a?; string c?; string...; |}>{"a": "AA", "b": "bbb", "c": "CC"}, r);
}

type QuotedFieldNameWithEscapeChars record {|
    int 'd\.\ \@\#d;
|};

type QuotedSubFieldNameWithEscapeChars record {|
    QuotedFieldNameWithEscapeChars 'd\.\ \@\#d;
|};

function testQuotedFieldNamesWithEscapeCharacters() {
    json jsonMapping = {"d. @#d": 6};
    json r = jsonMapping.cloneReadOnly();
    QuotedFieldNameWithEscapeChars newRec = <QuotedFieldNameWithEscapeChars>r;
    assert(6, newRec.'d\.\ \@\#d);
    jsonMapping = {"d. @#d": 9};
    newRec = checkpanic jsonMapping.fromJsonWithType(QuotedFieldNameWithEscapeChars);
    assert(9, newRec.'d\.\ \@\#d);
    newRec.'d\.\ \@\#d = 7;
    assert(7, newRec.'d\.\ \@\#d);
    jsonMapping = {"d. @#d": 8};
    newRec = checkpanic jsonMapping.cloneWithType(QuotedFieldNameWithEscapeChars);
    assert(8, newRec.'d\.\ \@\#d);
}

function testQuotedSubFieldNamesWithEscapeCharacters() {
    json jsonMapping = {"d. @#d": {"d. @#d": 7}};
    json r = jsonMapping.cloneReadOnly();
    QuotedSubFieldNameWithEscapeChars newRec = <QuotedSubFieldNameWithEscapeChars>r;
    assert(7, newRec.'d\.\ \@\#d.'d\.\ \@\#d);
    jsonMapping = {"d. @#d": {"d. @#d": 9}};
    newRec = checkpanic jsonMapping.fromJsonWithType(QuotedSubFieldNameWithEscapeChars);
    assert(9, newRec.'d\.\ \@\#d.'d\.\ \@\#d);
    newRec.'d\.\ \@\#d.'d\.\ \@\#d = 8;
    assert(8, newRec.'d\.\ \@\#d.'d\.\ \@\#d);
    jsonMapping = {"d. @#d": {"d. @#d": 10}};
    newRec = checkpanic jsonMapping.cloneWithType(QuotedSubFieldNameWithEscapeChars);
    assert(10, newRec.'d\.\ \@\#d.'d\.\ \@\#d);
}

function assert(anydata expected, anydata actual) {
    if (expected != actual) {
        typedesc<anydata> expT = typeof expected;
        typedesc<anydata> actT = typeof actual;
        panic error("{AssertionError}", message = "expected [" + expected.toString() + "] of type [" + expT.toString() +
            "], but found [" + actual.toString() + "] of type [" + actT.toString() + "]");
    }
}

function useIo(function(any... values) returns error? output) {
    _ = output;
}

public function main() {
    useIo(io:println);
    testBasicDataTypeMaps();
    testInclusiveRecordTypes();
    testRecordsWithOptionalFields();
    testQuotedFieldNamesWithEscapeCharacters();
    testQuotedSubFieldNamesWithEscapeCharacters();
}

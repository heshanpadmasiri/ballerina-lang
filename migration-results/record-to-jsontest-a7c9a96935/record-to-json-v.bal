import ballerina/io as _;

public function main() {
    testOpenRecordToJson();
    testNestedRecordModification();
}

function testOpenRecordToJson() {
    record {|
        string fname = "John";
        string lname = "Doe";
        string...;
    |} person = {"country": "Sri Lanka"};

    json j1 = person;
    assert(<json>{"fname": "John", "lname": "Doe", "country": "Sri Lanka"}, j1);

    map<json> mJ1 = <map<json>>j1;
    mJ1["city"] = "Colombo 3";
    assert(<json>{"fname": "John", "lname": "Doe", "country": "Sri Lanka", "city": "Colombo 3"}, mJ1);
}

function testNestedRecordModification() {
    record {|
        string name;
        record {|
            record {|
                int x;
                float...;
            |} nestedL2;
        |} nestedL1;
    |} rec = {
        name: "John",
        nestedL1: {
            nestedL2: {
                x: 100
            }
        }
    };

    json jR = rec;
    json nestedL2 = checkpanic jR.nestedL1.nestedL2;
    map<json> l2M = <map<json>>nestedL2;
    l2M["restF1"] = 12.34;
    json expected = {
        "name": "John",
        "nestedL1": {
            "nestedL2": {
                "x": 100,
                "restF1": 12.34
            }
        }
    };
    assert(expected, jR);
}

function assert(anydata expected, anydata actual) {
    if (expected != actual) {
        typedesc<anydata> expT = typeof expected;
        typedesc<anydata> actT = typeof actual;
        string detail = "expected [" + expected.toString() + "] of type [" + expT.toString()
                            + "], but found [" + actual.toString() + "] of type [" + actT.toString() + "]";
        panic error("{AssertionError}", message = detail);
    }
}

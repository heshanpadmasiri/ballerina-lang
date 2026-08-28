import ballerina/io;

json j1 = {
    fname: "Mary💦",
    lname: "Jane",
    address: {
        line: "20 Palm Grove",
        city: "Colombo 03",
        country: "Sri Lanka🦾"
    }
};

public function main() {
    io:println(testJsonAccess()); // @output 19
    io:println(testJsonOptionalAccess()); // @output 9
}

function testJsonAccess() returns int {
    string s = extractFieldValue(checkpanic j1.fname);
    s += extractFieldValue(checkpanic j1.lname);
    s += extractFieldValue(checkpanic j1.address.country);
    return s.length();
}

function testJsonOptionalAccess() returns int {
    string s = extractFieldValue(checkpanic j1?.fname);
    s += extractFieldValue(checkpanic j1?.lname);
    return s.length();
}

function extractFieldValue(json fieldValue) returns string {
    any a = fieldValue;
    if a is string {
        return a;
    } else if a is json {
        return "Error";
    }
    return "";
}

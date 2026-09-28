
import testorg/test_project.c.d as d;
import ballerina/io;

function testJsonToRecord() returns d:Person|error {
    json j = {"name":"John", "age":30, "adrs": {"street": "20 Palm Grove", "city":"Colombo 03", "country":"Sri Lanka"}};
    var p = check j.cloneWithType(d:Person);
    return p;
}

function testMapToRecord() returns d:Person|error {
    map<anydata> m1 = {"street": "20 Palm Grove", "city":"Colombo 03", "country":"Sri Lanka"};
    map<anydata> m2 = {"name":"John", "age":30, "adrs": m1};
    d:Person p = check m2.cloneWithType(d:Person);
    return p;
}
public function main() returns error? {
    d:Person jsonPerson = check testJsonToRecord();
    io:println(jsonPerson.name); // @output John
    io:println(jsonPerson.age); // @output 30
    io:println(jsonPerson.adrs.street); // @output 20 Palm Grove
    io:println(jsonPerson.adrs.city); // @output Colombo 03
    io:println(jsonPerson.adrs.country); // @output Sri Lanka

    d:Person mapPerson = check testMapToRecord();
    io:println(mapPerson.name); // @output John
    io:println(mapPerson.age); // @output 30
    io:println(mapPerson.adrs.street); // @output 20 Palm Grove
    io:println(mapPerson.adrs.city); // @output Colombo 03
    io:println(mapPerson.adrs.country); // @output Sri Lanka
}

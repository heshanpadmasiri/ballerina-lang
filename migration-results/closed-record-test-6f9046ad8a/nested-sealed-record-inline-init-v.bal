import ballerina/io;

final string child = "Bob";
type Person record {|
    string name = "default first name";
    string fname = "";
    string lname = "";
    map<any> adrs = {};
    int age = 999;
    Family family = {spouse: "Jane"};
|};
type Family record {|
    string spouse = "";
    int noOfChildren = 0;
    string[] children = ["Alex", child];
|};
function testCreateStruct() returns Person { Person emp = {lname: "Doe"}; return emp; }
public function main() {
    io:println(testCreateStruct()); // @output {"name":"default first name","fname":"","lname":"Doe","adrs":{},"age":999,"family":{"spouse":"Jane","noOfChildren":0,"children":["Alex","Bob"]}}
}

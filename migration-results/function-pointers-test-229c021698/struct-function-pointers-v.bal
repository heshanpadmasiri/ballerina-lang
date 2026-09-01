import ballerina/io;

type Person record {|
    string fname;
    string lname;
    function (string, string) returns string getName?;
    function (Person) returns string getPersonName?;
|};
public function main() {
    [string, string] values = test1();
    io:println(values.length()); // @output 2
    io:println(values[0]); // @output bob white
    io:println(values[1]); // @output smith, tom
    io:println(test3()); // @output white, bob
}
function getFullName(string f, string l) returns string => l + ", " + f;
function test1() returns [string, string] {
    Person bob = {fname: "bob", lname: "white", getName: function (string f, string l) returns string => f + " " + l};
    Person tom = {fname: "tom", lname: "smith", getName: getFullName};
    function (string, string) returns string fp1 = <function (string, string) returns string> bob["getName"];
    function (string, string) returns string fp2 = <function (string, string) returns string> tom["getName"];
    return [fp1(bob.fname, bob.lname), fp2(tom.fname, tom.lname)];
}
function getPersonNameFullName(Person p) returns string => p.lname + ", " + p.fname;
function test3() returns string {
    Person bob = {fname: "bob", lname: "white", getPersonName: getPersonNameFullName};
    function (Person) returns string fp = <function (Person) returns string> bob["getPersonName"];
    return fp(bob);
}

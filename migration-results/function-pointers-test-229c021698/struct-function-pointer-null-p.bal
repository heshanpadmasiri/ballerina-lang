type Person record {|
    string fname;
    string lname;
    function (string, string) returns string getName?;
|};
public function main() { _ = test2(); }
function test2() returns string {
    Person bob = {fname: "bob", lname: "white"};
    function (string, string) returns string fp = <function (string, string) returns string> bob["getName"]; // @panic
    return fp(bob.fname, bob.lname);
}

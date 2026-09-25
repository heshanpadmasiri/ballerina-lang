type Person record {|
    string fname = "";
    string lname = "";
    (function(string, string) returns string)? getName = ();
|};
function testNilableFuncPtrInvocation() {
    Person bob = {fname: "bob", lname: "white"};
    bob.getName = function(string fname, string lname) returns string { return fname + " " + lname; };
    (function(string, string) returns string)? fp = bob.getName;
    string? x = fp(bob.fname, bob.lname); // @error
}
function testNilableFuncPtrInvocation2() {
    Person bob = {fname: "bob", lname: "white"};
    (function(string, string) returns string)? fp = bob.getName;
    string? x = fp(bob.fname, bob.lname); // @error
}

type Person record {
    string fname = "";
    string lname = "";
    (function (string, string) returns string)|() getName = ();
};

function testNilableFuncPtrInvocation() {
    Person bob = {fname:"bob", lname:"white"};
    bob.getName = function (string fname, string lname) returns string {
        return fname + " " + lname;
    };
    string? x = bob.getName(bob.fname, bob.lname); // @error
}

function testNilableFuncPtrInvocation2() {
    Person bob = {fname:"bob", lname:"white"};
    string? x = bob.getName(bob.fname, bob.lname); // @error
}

type PersonB record {
    string fname = "";
    string lname = "";
    (function (string, string) returns string)? getName = ();
};

function testNilableFuncPtrInvocation3() returns string? {
    PersonB bob = {fname:"Bob", lname:"White"};
    bob.getName = function (string fname, string lname) returns string {
        return fname + " " + lname;
    };
    string? x = bob.getName(bob.fname, bob.lname); // @error
    return x;
}

function testNilableFuncPtrInvocation4() returns string? {
    PersonB bob = {fname:"Bob", lname:"White"};
    string? x = bob.getName(bob.fname, bob.lname); // @error
    return x;
}

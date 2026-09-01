type Person record {
    string fname;
    string lname;
    function (string, string) returns string getName?;
};

function getFullName(string f, string l) returns string {
    return l + ", " + f;
}

function test1() returns [string, string] {
    Person bob = {fname: "bob", lname: "white"};
    Person tom = {fname: "tom", lname: "smith", getName: getFullName};

    function (string, string) returns string fp = <function (string, string) returns string> tom["getName"];
    string y = fp(tom.fname, tom); // @error
    string x = bob.fname;
    return [x, y];
}

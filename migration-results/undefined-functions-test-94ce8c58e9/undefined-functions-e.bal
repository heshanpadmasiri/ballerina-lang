string str = "This is a test string";

int index = str.index("T"); // @error
string s = str.add("extra string"); // @error

function testFunction1() {
    [int, string, float, map<string>] tup = [10, "Foo", 12.34, {"k":"Bar"}];
    int result = 0;
    tup.forEach(function (string|int|map<string>|float x) {
        if (x is int) {
            result += 10;
        } else if (x is string) {
            result += x.length();
        } else if (x is float) {
            result += <int>x;
        } else {
            result += x["k"].length(); // @error
        }
    });

    map<string> addrMap = {
            line1: "No. 20",
            line2: "Palm Grove",
            city: "Colombo 03"
    };
    addrMap.delete("city"); // @error
}

class ManagerR {
    function func(int i) returns int => i;
}

class CompanyR {
    function func(int i) returns string => (i+1).toString();
}

class EmployeeR {
    function func(int i) returns int => i;
}

function testAccessingMethodOnUnionObjectTypeNegative() {
    ManagerR|CompanyR ob1 = new CompanyR();
    _ = ob1.func(); // @error

    (function (int i) returns int)|function (int i) returns string func1 = ob1.func;
    _ = func1(1); // @error

    var func2 = ob1.func;
    _ = func2(1); // @error

    ManagerR|EmployeeR ob2 = new EmployeeR();
    _ = ob2.func(); // @error

    var func3 = ob1.func;
    _ = func3(1); // @error
}

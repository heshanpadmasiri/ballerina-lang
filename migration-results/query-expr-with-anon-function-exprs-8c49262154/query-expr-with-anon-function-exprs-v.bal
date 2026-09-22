import ballerina/io;

type Person record {|
    string firstName;
    string lastName;
    int age;
|};

type Employee record {|
    string firstName;
    string lastName;
    string dept;
|};

type Card record {|
    string msg;
    int noOfEmp;
|};

int y = 10;
Person[] personList = [
    {firstName: "Alex", lastName: "George", age: 23},
    {firstName: "Ranjan", lastName: "Fonseka", age: 30},
    {firstName: "John", lastName: "David", age: 33}
];
Employee[] employeeList = [
    {firstName: "Alex", lastName: "George", dept: "Engineering"},
    {firstName: "John", lastName: "David", dept: "HR"},
    {firstName: "Alex", lastName: "Fonseka", dept: "Operations"}
];

function testQueryWithAnonFuncExprInLetClause() {
    int[] x = [1, 2];
    (function () returns int)[] fn = from int m in x
        let function () returns int func = function () returns int => m * y
        select func;
    assertEqual(fn.length(), 2);
    function () returns int f = fn[0];
    assertEqual(f(), 10);
    f = fn[1];
    assertEqual(f(), 20);
}

function testQueryWithAnonFuncExprInWhereClause() {
    int[] x = [1, 2];
    int[] arr = from int m in x
        let function () returns int func = function () returns int => m * y
        where func === function () returns int => 20
        select m;
    assertEqual(arr.length(), 0);
}

function testQueryWithAnonFuncExprInSelectClause() {
    int[] x = [1, 2];
    (function () returns int)[] fn = from int m in x
        select function () returns int => m * y;
    assertEqual(fn.length(), 2);
    function () returns int f = fn[0];
    assertEqual(f(), 10);
    f = fn[1];
    assertEqual(f(), 20);
}

function testQueryWithAnonFuncExprInSelectClause2() {
    int[] x = [1, 2];
    (function () returns int)[] fn = from int m in x
        select function () returns int => 0;
    assertEqual(fn.length(), 2);
    function () returns int f = fn[0];
    assertEqual(f(), 0);
    f = fn[1];
    assertEqual(f(), 0);
}

function testNestedQueryWithAnonFuncExpr() {
    int[] x = [1, 2];
    int[] z = [10, 20];
    (function () returns int)[] fn = from int m in x
        from int n in z
        where n == m * y
        select function () returns int => n;
    assertEqual(fn.length(), 2);
    function () returns int f = fn[0];
    assertEqual(f(), 10);
    f = fn[1];
    assertEqual(f(), 20);
}

function testComplexQueryWithAnonFuncExpr() {
    (function () returns string)[] fn = from Person p in personList
        select function () returns string => p.firstName + " " + p.lastName;
    assertEqual(fn.length(), 3);
    function () returns string f = fn[0];
    assertEqual(f(), "Alex George");
    f = fn[1];
    assertEqual(f(), "Ranjan Fonseka");
    f = fn[2];
    assertEqual(f(), "John David");
}

function testComplexQueryWithAnonFuncExpr2() {
    (function () returns int)[] fn = from Person p in personList
        let int i = 10
        select function () returns int { return i + p.age; };
    assertEqual(fn.length(), 3);
    function () returns int f = fn[0];
    assertEqual(f(), 33);
    f = fn[1];
    assertEqual(f(), 40);
    f = fn[2];
    assertEqual(f(), 43);

    (function () returns function)[] fn2 = from Person p in personList
        let int i = 10
        select function () returns function {
            return function () returns int { int v = 20; return v + i + p.age; };
        };
    assertEqual(fn2.length(), 3);
    function () returns function f1 = fn2[0];
    function f2 = f1();
    int? v = f2 is (function () returns int) ? f2() : ();
    assertEqual(v is int, true);
    assertEqual(v, 53);
    f1 = fn2[1]; f2 = f1(); v = f2 is (function () returns int) ? f2() : ();
    assertEqual(v is int, true);
    assertEqual(v, 60);
    f1 = fn2[2]; f2 = f1(); v = f2 is (function () returns int) ? f2() : ();
    assertEqual(v is int, true);
    assertEqual(v, 63);

    (function () returns function)[] fn3 = from Person p in personList
        let function () returns function func = function () returns function {
            return function () returns int { int n = 20; return n + y + p.age; };
        }
        select func;
    f1 = fn3[0]; f2 = f1(); v = f2 is (function () returns int) ? f2() : ();
    assertEqual(v is int, true);
    assertEqual(v, 53);
    f1 = fn3[1]; f2 = f1(); v = f2 is (function () returns int) ? f2() : ();
    assertEqual(v is int, true);
    assertEqual(v, 60);
    f1 = fn3[2]; f2 = f1(); v = f2 is (function () returns int) ? f2() : ();
    assertEqual(v is int, true);
    assertEqual(v, 63);

    (function () returns Card)[] fn4 = from var person in personList
        order by person.firstName descending
        select function () returns Card {
            string hello = "Hello ";
            function () returns string ff = function () returns string => hello + person.firstName;
            return {msg: ff(), noOfEmp: 25 + y};
        };
    assertEqual(fn4.length(), 3);
    function () returns Card f3 = fn4[0];
    Card card = f3();
    assertEqual(card.msg, "Hello Ranjan");
    assertEqual(card.noOfEmp, 35);
    f3 = fn4[1]; card = f3();
    assertEqual(card.msg, "Hello John");
    assertEqual(card.noOfEmp, 35);
}

function testInnerQueryWithAnonFuncExpr() {
    var fn1 = from var person in personList
        from var empFunc in (from var emp in employeeList select function () returns string => emp.firstName + " " + emp.dept)
        where person.firstName == "Alex"
        limit 2
        select function () returns string => empFunc() + " " + person.age.toString();
    assertEqual(fn1.length(), 2);
    function () returns string f = fn1[0];
    assertEqual(f(), "Alex Engineering 23");
    f = fn1[1];
    assertEqual(f(), "John HR 23");

    var fn2 = from var {firstName: fnm, lastName: lnm, age: _} in personList
        from var empFunc in (from var emp in employeeList select function () returns string => emp.dept)
        where fnm == "Alex"
        limit 2
        select function () returns string => fnm + " " + lnm + " in " + empFunc();
    assertEqual(fn2.length(), 2);
    f = fn2[0];
    assertEqual(f(), "Alex George in Engineering");
    f = fn2[1];
    assertEqual(f(), "Alex George in HR");
}

int[] arr = [3, 4, 5];
(function () returns int)[] globalFn1 = from int m in arr select function () returns int => m * y;
(function () returns string)[] globalFn2 = from Person p in personList select function () returns string => p.firstName + " " + p.lastName;
int[] globalFn3 = from int m in arr
    let function () returns int func = function () returns int => m * y
    where func === function () returns int { return 20; }
    select m;
(function () returns string)[] globalFn4 = from var {firstName, lastName, age: _} in personList
    where firstName == "Alex"
    select function () returns string => "Hello " + firstName + " " + lastName;
(function () returns Card)[] globalFn5 = from var person in personList
    from var empFunc in (from var {firstName, lastName: _, dept} in employeeList select function () returns string => firstName + " " + dept)
    where person.firstName == "Alex"
    limit 2
    select function () returns Card => {msg: empFunc(), noOfEmp: 25 + y};
var globalFn6 = from var person in personList
    select function () returns (function() returns (function () returns string)) =>
        function() returns (function () returns string) => function () returns string => person.firstName + " " + person.lastName;
(function () returns string)[] globalFn7 = messageFunc1("John");
string hello = "Hello ";
(function () returns string)[] globalFn8 = messageFunc2("John");
var globalFn9 = from var empFunc in (from var {firstName, lastName: _, dept: _} in employeeList
    select function () returns string {
        var grades = from var i in ["A", "B", "C"] select i;
        return firstName + "'s grades:" + grades.toString();
    }) select empFunc;

function messageFunc1(string name) returns (function () returns string)[] {
    return from var empFunc in (from var {firstName: _, lastName: _, dept} in employeeList
        select function () returns string => hello + name + " in " + dept)
        select empFunc;
}

function messageFunc2(string name) returns (function () returns string)[] {
    return from var _ in personList
        from var {firstName, lastName: _, dept} in employeeList
        order by firstName, dept descending
        limit 4
        select function () returns string => hello + name + " in " + dept;
}

function testGlobalQueryWithAnonFuncExpr() {
    assertEqual(globalFn1.length(), 3);
    function () returns int f1 = globalFn1[0]; assertEqual(f1(), 30);
    f1 = globalFn1[1]; assertEqual(f1(), 40);
    f1 = globalFn1[2]; assertEqual(f1(), 50);
    assertEqual(globalFn2.length(), 3);
    function () returns string f2 = globalFn2[0]; assertEqual(f2(), "Alex George");
    f2 = globalFn2[1]; assertEqual(f2(), "Ranjan Fonseka");
    f2 = globalFn2[2]; assertEqual(f2(), "John David");
    assertEqual(globalFn3.length(), 0);
    assertEqual(globalFn4.length(), 1);
    function () returns string f4 = globalFn4[0]; assertEqual(f4(), "Hello Alex George");
    assertEqual(globalFn5.length(), 2);
    function () returns Card f5 = globalFn5[0]; Card card = f5();
    assertEqual(card.msg, "Alex Engineering"); assertEqual(card.noOfEmp, 35);
    f5 = globalFn5[1]; card = f5();
    assertEqual(card.msg, "John HR"); assertEqual(card.noOfEmp, 35);
    assertEqual(globalFn6.length(), 3);
    function () returns (function() returns (function () returns string)) f6 = globalFn6[0];
    function() returns (function () returns string) f6a = f6(); function () returns string f6b = f6a();
    assertEqual(f6b(), "Alex George");
    f6 = globalFn6[1]; f6a = f6(); f6b = f6a(); assertEqual(f6b(), "Ranjan Fonseka");
    f6 = globalFn6[2]; f6a = f6(); f6b = f6a(); assertEqual(f6b(), "John David");
    assertEqual(globalFn7.length(), 3);
    function () returns string f7 = globalFn7[0]; assertEqual(f7(), "Hello John in Engineering");
    f7 = globalFn7[1]; assertEqual(f7(), "Hello John in HR");
    f7 = globalFn7[2]; assertEqual(f7(), "Hello John in Operations");
    assertEqual(globalFn8.length(), 4);
    f7 = globalFn8[0]; assertEqual(f7(), "Hello John in Operations");
    f7 = globalFn8[1]; assertEqual(f7(), "Hello John in Operations");
    f7 = globalFn8[2]; assertEqual(f7(), "Hello John in Operations");
    f7 = globalFn8[3]; assertEqual(f7(), "Hello John in Engineering");
    assertEqual(globalFn9.length(), 3);
    function () returns string f8 = globalFn9[0]; assertEqual(f8(), "Alex's grades:[\"A\",\"B\",\"C\"]");
    f8 = globalFn9[1]; assertEqual(f8(), "John's grades:[\"A\",\"B\",\"C\"]");
    f8 = globalFn9[2]; assertEqual(f8(), "Alex's grades:[\"A\",\"B\",\"C\"]");
}

public function main() {
    testQueryWithAnonFuncExprInLetClause();
    testQueryWithAnonFuncExprInWhereClause();
    testQueryWithAnonFuncExprInSelectClause();
    testQueryWithAnonFuncExprInSelectClause2();
    testNestedQueryWithAnonFuncExpr();
    testComplexQueryWithAnonFuncExpr();
    testComplexQueryWithAnonFuncExpr2();
    testInnerQueryWithAnonFuncExpr();
    testGlobalQueryWithAnonFuncExpr();
}

function assertEqual(any actual, any expected) {
    if actual is anydata && expected is anydata && actual == expected { return; }
    if actual === expected { return; }
    io:println(string `Assertion error: expected ${expected.toString()} found ${actual.toString()}`);
    panic error(string `Assertion error: expected ${expected.toString()} found ${actual.toString()}`);
}

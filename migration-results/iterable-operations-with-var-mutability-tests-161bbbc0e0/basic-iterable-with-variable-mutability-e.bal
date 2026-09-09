function testBasicMap2() returns [int, string, map<string>] {
    int count = 0;
    string str = "start";
    map<string> m = {a: "A", b: "B", c: "C", d: "D", e: "E"};
    map<string> modified = m.entries().'map(function ([string, string] tuple) returns [string, string] {
        var [key, value] = tuple;
        str = str + "-" + key + " : " + value;
        count += 10;
        return [key, value];
    }).filter(function ([string, string] v) returns boolean {
        var [k, t] = v; // @error unused variable 't'
        if (k == "a" || k == "e") {
            count += 10;
            return true;
        }
        return false;
    }).'map(function ([string, string] v) returns string {
        var [v1, v2] = v;
        count += 10;
        return v1 + v2;
    });
    str = str + "-end";
    count += 1;
    return [count, str, modified];
}

type Student record { string fname; int age; };

function recordTest() returns [int, string[]] {
    boolean status = true;
    int randomNum = 0;
    Student[] studentArr = [{fname: "aa", age: 30}, {fname: "bb", age: 20}, {fname: "cc", age: 24}];
    int count = studentArr.filter(function (Student stu) returns boolean { // @error unused variable 'count'
        randomNum += 2;
        return status && stu.age < 25;
    }).length();
    string[] names = studentArr.'map(function (Student stu) returns string { return stu.fname; });
    randomNum += 10;
    return [randomNum, names];
}

function testIgnoredValue() returns string {
    string str = "The start-";
    string[] s = ["abc", "cde", "pqr", "xy"];
    string[] filteredArr = s.filter(function (string s1) returns boolean { // @error unused variable 'filteredArr'
        return s1.length() == 3;
    }).'map(function (string s1) returns string {
        str = str + " hello " + s1 + " :) bye :) ";
        return str + s1;
    });
    str = str + "-The end";
    return str.trim();
}

function multipleIterableOps() returns string[] {
    string[] strArr = [];
    int index = 0;
    string currency = "USD";
    var closure = function (string key) { strArr[index] = currency; index += 1; };
    closure("key");
    map<int> currencies = {USD: 318, EUR: 322, GBP: 400};
    currencies.entries().forEach(function ([string, int] pair) {
        var [x, y] = pair; // @error unused variable 'y'
        strArr[index] = x;
        index += 1;
    });
    return strArr;
}

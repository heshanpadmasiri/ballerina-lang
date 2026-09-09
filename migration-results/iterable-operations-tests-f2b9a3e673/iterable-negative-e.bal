int count = 0;
string word = "";

function test1() {
    int x = 0;
    x.forEach(function (int i) { count = count + i;}); // @error
    string y = "foo";
    y.map(function (string s) returns int { return s.length();}); // @error
}

function test2() {
    string[] y = ["1", "a"];
    y.length(); // @error
    y.filter(function (int i, string x) returns boolean { // @error
        return true;
    }).forEach(function (string x) { word = x;});
}

function test3() {
    map<string> z = {a:"1", b:"2"};
    string[] keys = z.map(function (string s) returns [string, string] {
                         return [s, "value"];
    }).keys();
}

function test4() {
    map<any> z = {a:"1", b:"2"};
    map<string> a = z.map(function (any x) returns [string, string] { // @error
                           string s = <string>x;
                           return [s, "value"];
                       });
    map<any> m = z.filter(function (string s) returns boolean { // @error
          return s == "";
    });
    any x = z.filter(function (string s) returns boolean { // @error
         return s == "";
     });
}

function test5() {
    string[] s = ["1", "a"];
    int x;
    x = s.forEach(function (string s1) { word = word + s1;}); // @error
    var [z, y] = s.map(function (string value) returns string { // @error
                           return value.toUpperAscii; // @error
                       });
}

function test6() {
    string[] s = ["1", "a"];
    _ = s.length(test5); // @error
    s.filter(); // @error
    int i = 10;
    s.forEach(i); // @error
}

function test7() {
    string[] s = ["foo", "bar"];
    s.forEach(function ([string, string, string] z) {}); // @error
    s.forEach(function () {}); // @error
    s.filter(function (string s1) returns [boolean, int] { return [true, 1]; }); // @error @error
    s.filter(function (string s1) {}); // @error @error
    s.filter(function (person p) {}); // @error @error @error
    _ = s.filter(function (string s1) returns person { return (); }); // @error
}

function test8() {
    int[] arr = [-5, 2, 4, 5, 7, -8, -3, 2];
    int[] a = arr.map(function (int v) returns any { // @error
                        return v + 1;
                   });
}

function test9() {
    int[] arr = [-5, 2, 4, 5, 7, -8, -3, 2];
    int[] a = arr.map(function (int v) returns int { // @error
                        return v + 1;
                   }).map(function (int v) returns string {
                        return "Test" + v.toString();
                   });
}

function test10() {
    int[] arr = [-5, 2, 4, 5, 7, -8, -3, 2];
    int[] a = arr.map(function (int v) returns int { // @error
                        return v + 1;
                   }).map(function (int v) returns string {
                        return "Test" + v.toString();
                   }).filter(function (string s) returns boolean { return true; });
}

function test11() {
    map<any> z = {a:"1", b:"2"};
    map<any> m = z.filter(function (string s) returns boolean { // @error
          return s == "";
    });
    string x = z.filter(function (any s) returns boolean { // @error
         return s == ();
    });
}

function testVarInLHS() {
    int[] numbers = [-5, -3, 2, 7, 12];
    var filtered = numbers.filter(function (int i) returns boolean {
            return i; // @error
        });
}

function testVarInLHS2() {
    int[] numbers = [-5, -3, 2, 7, 12];
    var mapped = numbers.filter(function (int value) returns boolean {
            return value > 0;
        }).map(function (int value) returns [string, float] {
            return [value.toString(), value]; // @error
        });
}

function testIndexBasedAccess() {
    int[] numbers = [-5, -3, 2, 7, 12];
    var x = numbers.filter(function (int i) returns boolean {
            return i >= 0;
        })[0];
}

int[] globalNumbers = [-5, -3, 2, 7, 12];

function testAnydataInLHS() {
    anydata mapped = globalNumbers.filter(function (int value) returns boolean {
               return value > 0;
           }).map(function (int value) returns [string, float] {
               return [value.toString(), value]; // @error
           });
}

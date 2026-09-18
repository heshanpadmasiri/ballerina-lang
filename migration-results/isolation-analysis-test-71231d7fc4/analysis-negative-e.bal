// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

int a = 12;

var b = {
    a: "Hello",
    b: "world",
    c: "from Ballerina"
};

string c = "c";

int[] d = [1, 2];

isolated function invalidIsolatedFunctionWithMutableGlobalVarRead() returns int {
    int w = a; // @error // @error
    record {} x = b; // @error // @error

    string? y = b.a; // @error // @error
    string? z = b[c]; // @error // @error // @error

    return d[a]; // @error // @error
}

isolated function invalidIsolatedFunctionWithMutableGlobalVarWrite() {
    a = 321; // @error
    b = { // @error
        a: "a",
        b: "b",
        c: "c"
    };

    b.a = "aa"; // @error
    b["c"] = "cc"; // @error

    d[a] = 8765; // @error // @error
}

isolated function invalidIsolatedFunctionWithNonIsolatedFunctionCall() {
    int _ = 1;
    int _ = nonIsolated(); // @error
}

function nonIsolated() returns int => a;

class Foo {
    function getInt() returns int {
        return 1;
    }
}

isolated function invalidIsolatedFunctionWithNonIsolatedMethodCall() {
    Foo f = new;
    int _ = f.getInt(); // @error
}

isolated function invalidIsolatedFunctionWithWorkerDeclaration(int i) {
    int _ = i + 1;

    worker w1 {
        string _ = "hello world";
    }
}

isolated function invalidIsolatedFunctionWithStartCall() {
    future<int> ft = start nonIsolated(); // @error // @error
}

type Bar record {
    int a;
    int b;
};

final Bar bar = {
    a: 100,
    b: 200
};

isolated function invalidIsolationFunctionAccessingMutableStorageViaFinalVar() {
    int a = bar.a; // @error // @error
}

class Baz {
    int i;

    isolated function init(int j) {
        self.i = j + a; // @error
    }

    isolated function val() returns int {
        return self.i + d[0] + 100; // @error
    }
}

public class Listener {

    public function attach(service object {} s, string[]|string? name = ()) returns error? { return; }

    public function detach(service object {} s) returns error? { return; }

    public function 'start() returns error? { return; }

    public function gracefulStop() returns error? { return; }

    public function immediateStop() returns error? { return; }
}

service /s1 on new Listener() {
    isolated resource function get res1(map<int> j) {
        int _ = a + <int> j["val"]; // @error
    }

    resource isolated function get res2(string str) returns error? {
        self.res3();
        return error(str + c); // @error
    }

    isolated function res3() {
        int i = d[1]; // @error // @error
    }
}

service object {} s2 = service object {
    isolated resource function get res1(map<int> j) {
        int x = a + <int> j["val"]; // @error // @error
    }

    resource isolated function get res2(string str) returns error? {
        self.res3();
        return error(str + c); // @error
    }

    isolated function res3() {
        int _ = d[1]; // @error
    }
};

boolean bool = true;

isolated function testInvalidNonIsolatedAccessAsArgs() {
    diffParamKinds(a); // @error
    diffParamKinds(a, c, ...[bool, false]); // @error // @error // @error
    diffParamKinds(a, b = c); // @error // @error
    diffParamKinds(a, c, ...d); // @error // @error // @error
    diffParamKinds(a, ...[c, bool, 1, a]); // @error // @error // @error // @error
}

isolated function diffParamKinds(int a, string b = "hello", boolean|int... c) {
}

var testInvalidIsolatedModuleAnonFunc = isolated function () {
    int _ = nonIsolated() + d[0]; // @error // @error
    string _ = c + "world"; // @error
};

function testInvalidIsolatedAnonFunc() {
    var _ = isolated function () {
        int _ = nonIsolated() + d[0]; // @error // @error
        string _ = c + "world"; // @error
    };
}

// Invalid arrow functions as isolated functions.
type ISOLATED_FUNCTION isolated function (int) returns int;

ISOLATED_FUNCTION af1 = x => x + a; // @error

function testInvalidArrowFuncAsIsolatedFunction() {
    ISOLATED_FUNCTION af2 = x => d[0] + x; // @error // @error

    int y = 100;
    isolated function (int) returns int af3 = x => x + y; // @error // @error
}

public isolated function testInvalidNonIsolatedRemoteMethodCalls() {
    ClientClass f = new;
    f->bar(); // @error
    int _ = f->baz(a); // @error // @error
    int _ = f->baz(a, c, c); // @error // @error // @error // @error
}

client class ClientClass {
    remote function bar() {
    }

    remote function baz(int i, string... s) returns int => 1;
}

final int[] & readonly immutableIntArr = [0, 1];

isolated function invalidIsolatedFunctionWithForkStatement(int i) {
    int _ = immutableIntArr[1] + i;

    fork {
        worker w1 {

        }
    }
}

listener Listener ln = new;

isolated function testInvalidIsolatedFunctionAccessingNonIsolatedListener() {
    Listener ln2 = ln; // @error // @error
}

final map<int> intMap = {a: 1, b: 2};

isolated function testInvalidNonIsolatedFunctionWithNonIsolatedDefaults(int w = a, int[] x = getIntArray()) { // @error // @error
}

var testInvalidNonIsolatedAnonFunctionWithNonIsolatedDefaults =
    isolated function (boolean b, int[] y = getIntArray(), map<int> z = intMap) { // @error // @error
        if b {
            foreach var val in z {
                y.push(val);
            }
        }
    };

function getIntArray() returns int[] => d;

class NonIsolatedClass {
    final string a = "hello";
    private int[] b = [1, 2];

    isolated function getArray() returns int[] {
        lock {
            int[] x = self.b.clone();
            x.push(self.a.length());
            return x.clone();
        }
    }
}

final NonIsolatedClass nonIsolatedObject = new;

isolated function testInvalidAccessOfFinalNonIsolatedObjectInIsolatedFunction() {
    NonIsolatedClass cl = nonIsolatedObject; // @error // @error
    int[] arr = nonIsolatedObject.getArray(); // @error // @error
}

service class Service {
    resource function get foo() {
    }
}

service readonly class ReadOnlyService {
    resource function get foo() returns int => 1;
}

final Service ser1 = new;
Service ser2 = new;
ReadOnlyService ser3 = new;

isolated function testInvalidMutableServiceAccess() {
    any _ = ser1; // @error
    any _ = ser2; // @error
    any x3 = ser3; // @error // @error
}

function testAnonIsolatedFuncAccessingImplicitlyFinalVarsNegative(int[] i) {
   var fn1 = isolated function () returns int[] => i; // @error // @error

   int[][] x = [];
   foreach var j in x {
      var fn2 = isolated function () returns int[] { // @error
         j.push(...i); // @error // @error
         return j; // @error
      };
   }

   var fn3 = let int[] k = [i.length(), 1] in isolated function () returns int[] => k; // @error // @error

   var fn4 = let int[] k = i in isolated function (int[] l) returns int[] { // @error
      k.push(...l); // @error
      return k; // @error
   };

   (isolated function () returns int[])[] fn5 = // @error
      from var m in x
      where m.length() > 10
      let int[] n = []
      select isolated function () returns int[] {
         int[] y = m; // @error
         y.push(...n); // @error
         return y;
      };


   isolated function () returns int[] fn6 = () => i; // @error // @error

   foreach var j in x {
      isolated function () returns int[] fn7 = () => j; // @error // @error
   }

   isolated function () returns int[] fn8 = let int[] k = i in () => k; // @error // @error

   isolated function (int[]) returns int[] fn9 = let int[] k = i in (l) => k; // @error // @error
}

class TestInvalidAccessOfSelfAsCapturedVariableInIsolatedFunction {
    string[] words = [];
    int length = 3;

    isolated function getCount() returns int =>
        self.words.filter(
            isolated function (string word) returns boolean => word.length() == self.length).length(); // @error
}

object {} testInvalidAccessOfSelfAsCapturedVariableInIsolatedFunction = object {
    string[] words = [];
    int length = 3;

    isolated function getCount() returns int =>
        self.words.filter(
            isolated function (string word) returns boolean => self.length == word.length()).length(); // @error
};

final function () returns string nf1 = inferredButNotExplicitlyIsolatedFunc;
final var nf2 = nonIsolated;

isolated function testInvalidNonIsolatedFPCall() {
    var f = inferredButNotExplicitlyIsolatedFunc;
    string _ = f(); // @error

    string _ = nf1(); // @error

    var g = nf2;
    int _ = g(); // @error

    function () returns int i = nonIsolated;
    _ = i(); // @error

    function (int a, string b = "hello", boolean|int... c) j = diffParamKinds;
    _ = j(1); // @error

    TestInvalidNonIsolatedBoundMethodFPCall k = new;
    var f1 = k.nonIsolatedFn;
    f1(); // @error

    var f2 = k.isolatedFn;
    f2(); // @error
}

function inferredButNotExplicitlyIsolatedFunc() returns string => "bar";

class TestInvalidNonIsolatedBoundMethodFPCall {
    isolated function testInvalidNonIsolatedBoundMethodFPCall() {
        var f1 = self.nonIsolatedFn;
        f1(); // @error

        var f2 = self.isolatedFn;
        f2(); // @error
    }

    public function nonIsolatedFn() {
    }

    public isolated function isolatedFn() {
    }
}

public class TestInvalidNonIsolatedFunctionFieldFPCall {
    private final function () returns string f = () => "hello";

    isolated function testFunctionFieldFPCall() {
        function () returns string f1 = self.f;
        _ = f1(); // @error

        var f2 = self.f;
        string _ = f2(); // @error
    }
}

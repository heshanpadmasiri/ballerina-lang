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
import ballerina/lang.array;
isolated class InvalidIsolatedClassWithNonPrivateMutableFields {
    int a; // @error
    public map<int> b; // @error
    private final string c = "invalid";

    function init(int a, map<int> b) {
        self.a = a;
        self.b = b.clone();
    }
}

type IsolatedObject isolated object {};

IsolatedObject invalidIsolatedObjectConstructorWithNonPrivateMutableFields = isolated object {
    int a; // @error
    public map<int> b; // @error
    private final string c = "invalid";

    function init() {
        self.a = 1;
        self.b = {};
    }
};

type IsolatedObjectType isolated object {
    int a;
    string[] b;
};

isolated class InvalidIsolatedClassNotOverridingMutableFieldsInIncludedIsolatedObject {
    *IsolatedObjectType; // @error

    function init() {
        self.a = 1;
        self.b = [];
    }
}

IsolatedObject invalidIsolatedObjectNotOverridingMutableFieldsInIncludedIsolatedObject = isolated object IsolatedObjectType { // @error
   function init() {
       self.a = 1;
       self.b = [];
   }
};

isolated class InvalidIsolatedClassAccessingMutableFieldsOutsideLock {
    final int a = 1;
    private string b = "hello";
    private int[] c;

    function init(int[] c) {
        self.c = c.clone();
    }

    function getB() returns string => self.b; // @error

    function setB(string s) {
        self.b = s; // @error
    }

    function updateAndGetC(int i) returns int[] {
        lock {
            self.c.push(i); // OK
        }
        return self.c; // @error
    }
}

function testInvalidIsolatedObjectConstructorAccessingMutableFieldsOutsideLock() {
    isolated object {} _ = isolated object {
        final int a = 1;
        private string b = "hello";
        private int[] c = [];

        function getB() returns string => self.b; // @error

        function setB(string s) {
            self.b = s; // @error
        }

        function updateAndGetC(int i) returns int[] {
            lock {
                self.c.push(i); // OK
            }
            return self.c; // @error
        }
    };
}

int[] globIntArr = [1200, 12, 12345];
int[] globIntArrCopy = globIntArr;
int[] globIntArrCopy2 = globIntArrCopy;
string globStr = "global string";
map<boolean> globBoolMap = {a: true, b: false};

function accessGlobBoolMap(string s) {
    _ = (globBoolMap["a"] ?: true) && (globStr == s);
}

isolated class InvalidIsolatedClassWithNonUniqueInitializerExprs {
    private int[][] a;
    private map<boolean> b = globBoolMap; // @error
    private record {} c = {[globStr]: accessGlobBoolMap(globStr)};
    final string d = globStr;
    private table<record{ readonly int id; }> e = table key (id) [
        {id: 1, "name": "foo"},
        {id: 2, "name": string `str ${globStr}`}
    ];
    final readonly & xml[] f = [xml `hello ${globStr}`, xml `<!-- int: ${globIntArr[0]} -->`, xml `ok`,
                                xml `?pi ${globBoolMap["a"] is boolean ? "true" : globStr}?`];
    final int g = <int> checkpanic trap 'int:fromString(globStr);
    private float h;

    function init(int[][]? a) returns error? {
        self.a = a ?: [globIntArr, globIntArr]; // @error
        record {} rec = {"a": 1, "b": 2.0};
        anydata _ = rec;
        self.c = rec; // @error
        self.h = check 'float:fromString(globStr);
    }
}

function testInvalidIsolatedObjectWithNonUniqueInitializerExprs() {
    isolated object {} _ = isolated object {
        private int[][] a = [globIntArr, globIntArr]; // @error
        private map<boolean> b = globBoolMap; // @error
        private record {} c = {[globStr]: accessGlobBoolMap(globStr)};
        final string d = globStr;
        private table<record{ readonly int id; }> e = table key (id) [
            {id: 1, "name": "foo"},
            {id: 2, "name": string `str ${globStr}`}
        ];
        final readonly & xml[] f = [xml `hello ${globStr}`, xml `<!-- int: ${globIntArr[0]} -->`, xml `ok`,
                                    xml `?pi ${globBoolMap["a"] is boolean ? "true" : globStr}?`];
        final int g = <int> checkpanic trap 'int:fromString(globStr);
        private float h;

        function init() {
            record {} rec = {"a": 1, "b": 2.0};
            anydata ad = rec; // @error
            self.c = rec; // @error
            self.h = checkpanic 'float:fromString(globStr);
        }
    };
}

isolated class InvalidIsolatedClassWithInvalidCopyIn {
    public final record {} & readonly a;
    private int b;
    private map<boolean>[] c;

    function init(record {} & readonly a, int b, map<boolean>[] c) {
        self.a = a;
        self.b = b;
        self.c = c.clone();
    }

    function invalidCopyInOne(map<boolean> boolMap) {
        map<boolean> bm1 = {};
        lock {
            map<boolean> bm2 = {a: true, b: false};

            self.c[0] = globBoolMap; // @error
            self.c.push(boolMap); // @error
            self.c = [bm1, bm2]; // @error
        }
    }

    isolated function invalidCopyInTwo(map<boolean> boolMap) {
        map<boolean> bm1 = {};
        lock {
            map<boolean> bm2 = {};
            lock {
                map<boolean> bm3 = boolMap; // @error
                bm2 = bm3; // @error
            }

            self.c.push(boolMap); // @error
            self.c[0] = boolMap; // @error
            self.c = [bm1, bm2]; // @error
        }
    }
}

IsolatedObject invalidIsolatedObjectWithInvalidCopyIn = isolated object {
    public final record {} & readonly a = {"type": "final"};
    private int b = 0;
    private map<boolean>[] c = [];

    isolated function invalidCopyInOne(map<boolean> boolMap) {
        map<boolean> bm1 = {};
        lock {
            map<boolean> bm2 = {a: true, b: false};

            self.c[0] = boolMap; // @error
            self.c.push(boolMap); // @error
            self.c = [bm1, bm2]; // @error
        }
    }

    function invalidCopyInTwo(map<boolean> boolMap) {
        map<boolean> bm1 = {};
        lock {
            map<boolean> bm2 = {};
            lock {
                map<boolean> bm3 = boolMap; // @error
                bm2 = bm3; // @error
            }

            self.c.push(boolMap); // @error
            self.c[0] = globBoolMap; // @error
            self.c = [bm1, bm2]; // @error
        }
    }
};

isolated class InvalidIsolatedClassWithInvalidCopyOut {
    public final record {} & readonly a = {"type": "final"};
    private int b = 1;
    private map<boolean>[] c;

    function init() {
        self.c = [];
    }

    function invalidCopyOutOne(map<boolean>[] boolMaps) returns map<boolean>[] {
        map<boolean>[] bm1 = boolMaps; // @error
        lock {
            map<boolean>[] bm2 = [{a: true, b: false}];

            bm1 = self.c; // @error
            globBoolMap = bm2[0]; // @error
            bm1 = [self.c[0]]; // @error
            return self.c; // @error
        }
    }

    isolated function invalidCopyOutTwo(map<boolean>[] boolMaps) {
        map<boolean> bm1 = {}; // @error
        lock {
            map<boolean> bm2 = {};
            lock {
                map<boolean> bm3 = boolMaps[0].clone();
                bm1 = bm3; // @error
            }

            bm1 = self.c[0]; // @error
            bm1 = bm2; // @error
        }
    }
}

function testInvalidIsolatedObjectWithInvalidCopyOut() {
    isolated object {} _ = isolated object {
        private map<boolean>[] c = [];

        isolated function invalidCopyOutOne(map<boolean>[] boolMaps) returns map<boolean> {
            map<boolean>[] bm1 = boolMaps; // @error
            lock {
                map<boolean>[] bm2 = [{a: true, b: false}];

                bm1 = self.c; // @error
                bm1 = bm2; // @error
                bm1 = [self.c[0]]; // @error
                return self.c.pop(); // @error
            }
        }

        function invalidCopyOutTwo(map<boolean>[] boolMaps) {
            map<boolean> bm1 = {}; // @error
            lock {
                map<boolean> bm2 = {};
                lock {
                    map<boolean> bm3 = boolMaps[0].clone();
                    bm1 = bm3; // @error
                }

                globBoolMap = self.c[0]; // @error
                bm1 = bm2; // @error
            }
        }
    };
}

isolated class InvalidIsolatedClassWithNonIsolatedFunctionInvocation {
    private int[] x = [];

    function testInvalidNonIsolatedInvocation() {
        lock {
            int[] a = self.x;

            IsolatedClass ic = new;
            a[0] = ic.nonIsolatedFunc(); // @error
            a.push(ic.nonIsolatedFunc()); // @error

            a = nonIsolatedFunc(); // @error
        }
    }
}

IsolatedObject invalidIsolatedObjectWithNonIsolatedFunctionInvocation = isolated object {
    private int[] x = [];

    function testInvalidNonIsolatedInvocation() {
        lock {
            int[] a = self.x;

            IsolatedClass ic = new;
            a[0] = ic.nonIsolatedFunc(); // @error
            a.push(ic.nonIsolatedFunc()); // @error

            a = nonIsolatedFunc(); // @error
        }
    }
};

isolated class InvalidIsolatedClassWithInvalidObjectFields {
    IsolatedClass a = new; // Should be `final` // @error
    isolated object {} b = isolated object { // Should be `final` // @error
        final int i = 1;
        private map<int> j = {};
    };
    final object {} c = object {}; // should be an `isolated object` // @error
}
int globInt = 1;
isolated class IsolatedClass {
    function nonIsolatedFunc() returns int => globInt;
}

function nonIsolatedFunc() returns int[] {
    return [1, 2, 3];
}

isolated class InvalidIsolatedClassWithCopyInInsideBlock {
    private string[] uniqueGreetings = [];

    isolated function add(string[] greetings) {
        lock {
            if self.uniqueGreetings.length() == 0 {
                self.uniqueGreetings = greetings; // @error
            }
        }
    }
}

isolated class InvalidIsolatedClassWithInvalidCopyingWithClone {
    private anydata[] arr = [];
    private anydata[] arr2 = [];

    isolated function add(anydata val) {
        lock {
            self.arr.push(val); // @error

            self.addAgain(val); // @error
            outerAdd(val); // @error
            anydata clonedVal = val; // @error
            self.addAgain(clonedVal); // OK
            if val is anydata[] {
                self.arr.push(val.pop()); // @error

                lock {
                    self.arr.push(val.pop()); // @error
                }
            }

            if clonedVal is anydata[] {
                self.arr.push(clonedVal.pop()); // OK

                lock {
                    self.arr.push(clonedVal.pop()); // @error
                }
            }
        }
    }

    isolated function addAgain(anydata val) { }
}

isolated function outerAdd(anydata val) { }

decimal globDecimal = 0;

isolated class CurrentConfig {
    private decimal[2] x = [1, 2.0];
    private record {
        int[] a;
        decimal b;
        boolean c;
    } y = {a: [1, 2], b: 1.0, c: true};

    function foo(decimal arr) {
        decimal a = 0; // @error
        decimal a2 = 0; // @error

        lock {
            [a, globDecimal] = self.x.clone(); // @error
            [a2, globDecimal] = self.x; // @error
        }
    }

    function bar() {
        int[] a; // @error
        decimal b; // @error

        lock {
            boolean c; // @error
            {a, b, c} = self.y; // @error
            {a, b, c} = self.y.cloneReadOnly(); // @error
        }
    }
}

int[] y = [];
readonly & int[] z = [];

isolated class IsolatedClassWithInvalidVarRefs {
    private int[][] x;
    private int[] y;
    private any[] z;

    function init() {
        self.y = y; // @error
    }

    function push() {
        lock {
            self.x = let int[] z = y in [y, z]; // @error
            self.y = (let int[]? z = y in ((z is int[]) ? z : <int[]> [])); // @error
            self.x = let int[] v = z, int[] w = y in <int[][]> [z, v, w]; // @error
        }
    }

    isolated function nested() {
        any[] arr = let int[] v = y in [v]; // @error

        lock {
            self.z = let int[] v = y in [v, let int[] w = y in isolated function () returns int[2][] { return [w, v]; }]; // @error
        }
    }
}

isolated service class InvalidIsolatedServiceClassWithNonPrivateMutableFields {
    int a; // @error
    public map<int> b; // @error
    private final string c = "invalid";

    function init(int a, map<int> b) {
        self.a = a;
        self.b = b.clone();
    }
}

client isolated class InvalidIsolatedClientClassWithCopyInInsideBlock {
    private string[] uniqueGreetings = [];

    isolated function add(string[] greetings) {
        lock {
            if self.uniqueGreetings.length() == 0 {
                self.uniqueGreetings = greetings; // @error
            }
        }
    }
}

type IsolatedServiceObjectType isolated service object {
    int a;
    string[] b;
};

service isolated class InvalidIsolatedServiceClassNotOverridingMutableFieldsInIncludedIsolatedServiceObject {
    *IsolatedServiceObjectType; // @error

    function init() {
        self.a = 1;
        self.b = [];
    }
}

isolated int[] isolatedArr = [];

isolated service / on new Listener() {
    int[] x = []; // @error

    remote function foo() {
        self.x = [2, 3]; // @error
    }

    resource function get bar() {
        self.x = [2, 3]; // @error
    }

    function baz() {
        self.x = [2, 3]; // @error
    }

    isolated function qux() {
        globIntArr = []; // @error
    }

    isolated resource function get quux() {
        globIntArr = []; // @error
    }

    resource function get corge() {
        lock {
            self.x = [2, 3]; // @error
            isolatedArr = []; // @error
        }
    }
}

service object {} ser = isolated service object {
    int[] x = []; // @error

    remote function foo() {
        self.x = [2, 3]; // @error
    }

    resource function get bar() {
        self.x = [2, 3]; // @error
    }

    function baz() {
        self.x = [2, 3]; // @error
    }

    isolated function qux() {
        globIntArr = []; // @error
    }

    isolated resource function get quux() {
        globIntArr = []; // @error
    }

    resource function get corge() {
        lock {
            self.x = [2, 3]; // @error
            isolatedArr = []; // @error
        }
    }
};

isolated service class ServiceClass {
    int[] x = []; // @error

    remote function foo() {
        self.x = [2, 3]; // @error
    }

    resource function get bar() {
        self.x = [2, 3]; // @error
    }

    function baz() {
        self.x = [2, 3]; // @error
    }

    isolated function qux() {
        globIntArr = []; // @error
    }

    isolated resource function get quux() {
        globIntArr = []; // @error
    }

    resource function get corge() {
        lock {
            self.x = [2, 3]; // @error
            isolatedArr = []; // @error
        }
    }

    function quuz() {
        lock {
            self.x = [2, 3]; // @error
            isolatedArr = []; // @error
        }
    }
}

public class Listener {

    public function 'start() returns error? {}

    public function gracefulStop() returns error? {}

    public function immediateStop() returns error? {}

    public function detach(service object {} s) returns error? {}

    public function attach(service object {} s, string[]? name = ()) returns error? {}
}

isolated int[] x = [];

function testInvalidCopyInWithNonObjectSelf1(int[] 'self) {
    lock {
        x = 'self; // @error
    }
}

function testInvalidCopyInWithNonObjectSelf2() {
    lock {
        int[] 'self = [];
        x = 'self; // @error
    }
}

public isolated class IsolatedClassWithBoundMethodAccess {

    public isolated function bar() {
        isolated function () fn = self.baz; // @error
    }

    isolated function baz() {
    }
}

isolated class IsolatedClassWithInvalidCopyInInMethodCall {
    private map<int> m = {};

    isolated function baz() returns map<int>[] {
        map<int>[] y = [];

        lock {
            y[0] = self.m; // @error
            y.push(self.m); // @error
            array:push(y, self.m); // @error
        }

        return y;
    }

    function qux(map<int[]> y) {
        lock {
            _ = y.remove(self.m["a"].toString()); // @error
        }
    }
}

var isolatedObjectWithInvalidCopyInInMethodCall = isolated object {
    private map<int> m = {};

    isolated function baz() returns map<int>[] {
        map<int>[] y = [];

        lock {
            y[0] = self.m; // @error
            y.push(self.m); // @error
            array:push(y, self.m); // @error
            return y; // @error
        }
    }

    function qux(map<int[]> y) {
        lock {
            _ = y.remove(self.m["a"].toString()); // @error
        }
    }
};

isolated class IsolatedClassWithInvalidCopyOut2 {
    private map<int> m = {};

    isolated function baz() returns map<int>[] {
        map<int>[] y = [];
        map<int> z; // @error
        lock {
            map<int>[] y2 = [];
            y[0] = self.m; // @error
            z = self.m; // @error
            return y2; // @error
        }
    }
}

const fromMobile = "";
configurable string toMobile = ?;

isolated NonIsolatedClient cl = new;

service / on new Listener() {
   isolated resource function post foo() returns error? {
      Response resp; // @error
      lock {
         resp = check cl->sendMessage(fromMobile, toMobile, "Hi!"); // @error
      }
   }
}

type Response record {|
   string message;
   int id;
|};

public client class NonIsolatedClient {
   int i = 1;

   isolated remote function sendMessage(string x, string y, string z)
      returns Response|error => {message: "Hello", id: 0};
}

isolated class IsolatedClassWithQueryExprAsTransferOut {
    private isolated object {}[] arr = [];

    function getArr() returns isolated object {}[] {
        lock {
            return from var ob in self.arr select ob; // @error
        }
    }
}

isolated class IsolatedClassWithInvalidRawTemplateTransfer {
    private int[] arr = [];
    private isolated object {}[] arr2 = [];

    function getArrOne() returns any {
        lock {
            return `values: ${self.arr}`; // @error
        }
    }

    function getArrTwo() returns any {
        lock {
            return `values: OK ${self.arr.clone()} invalid ${self.arr2}`; // @error
        }
    }

    function getArrs(int[] intArr) returns any {
        lock {
            any val = `arr: ${intArr}`; // @error
            return `values: ${self.arr2}, ${"Hello"}, ${self.arr}, ${val}, ${self.arr.clone()}`; // @error
        }
    }
}

isolated class IsolatedClassWithInvalidQueryExpTransfer {
    private int[][] arrs = [];

    function f1() returns int[][] {
        lock {
            int[][] x = self.arrs;
            return from var item in x select item; // @error
        }
    }

    function f2(int[][] arr) {
        int[][] outerArr; // @error
        lock {
            int[][] x = [];

            foreach var item in arr { // @error
                if let int[] p = item in p.length() == 0 {
                    self.arrs.push(item);
                }
            }

            outerArr = from int[] item in x // @error
                            join var item2 in arr.clone() on item equals item2
                            let int[] p = item where p[p.length()] == 0
                            select p;
        }
    }

    function f3(int[][] arr) {
        lock {
            int[][] listResult = from var e in arr // @error
                    order by e[0] ascending
                    select e;

            error? res = from var e in self.arrs do { // @error
                arr.push(e); // @error
            };

            foreach var f in self.arrs {
                arr.push(f); // @error
            }

            int[][] innerArr = [];
            res = from var e in arr do { // @error
                innerArr.push(e.clone());
            };
            arr.push(...innerArr); // @error
        }
    }

    function f4() returns int[][] {
        lock {
            int[][] x = self.arrs;
            // Not yet allowed, may be allowed in the future.
            // https://github.com/ballerina-platform/ballerina-spec/issues/855#issuecomment-847829558
            return from var item in x select item.clone(); // @error
        }
    }

    function f5(int[][] arr, int[] a, int[] b) {
        lock {
            int[][] x = [];

            self.arrs = from int[] item in x
                            join var item2 in arr.clone() on item equals a // @error
                            let int[] p = item where p[p.length()] == 0
                            select p;

            self.arrs = from int[] item in x
                            join var item2 in arr.clone() on b equals a // @error
                            let int[] p = item where p[p.length()] == 0
                            select p;
        }
    }
}

isolated class IsolatedClassWithInvalidAccessOutsideLockInInitMethod {
    private int[][] arr;

    function init(int[] node) {
        self.arr = []; // OK

        self.arr.push(node); // @error
        self.arr[0] = node; // @error
    }
}

int[] mutableIntArr = [1, 2];

function getMutableIntArray() returns int[] => mutableIntArr;

var isolatedObjectConstructorWithInvalidAccessOutsideLockInInitMethod = isolated object {
    private int[][] arr;

    function init() {
        self.arr = []; // OK

        int[] node = getMutableIntArray();

        self.arr.push(node); // @error
        self.arr[0] = node; // @error
    }
};

isolated class IsolatedClassWithInvalidInitMethod {
    private int[][] arr;

    function init(int[] node) {
        self.arr = []; // OK

        lock {
            self.arr[0] = node; // @error
            self.arr.push(getMutableIntArray()); // @error
        }
    }
}

function testIsolatedObjectConstructorWithInvalidInitMethod() {
    var _ = isolated object {
        private int[][] arr;

        function init() {
            self.arr = []; // OK

            int[] node = getMutableIntArray();

            lock {
                self.arr.push(node); // @error
                int[] mutArr = getMutableIntArray(); // @error
                self.arr[0] = mutArr;
            }
        }
    };
}

isolated class TestInvalidAccessOfIsolatedObjectSelfInAnonFunctions {
    private int[][] arr = [];

    function init(int[] node) {
        function _ = function () {
            self.arr.push(node); // @error
        };
    }

    function f1(int[] node) {
        function _ = function () {
            self.arr.push(node); // @error
        };
    }

    function f2(int[] node) {
        lock {
            function _ = function () {
                object {} _ = isolated object {
                    private int[][] innerArr = [];

                    function innerF(int[] innerNode) {
                        function _ = function () {
                            self.innerArr.push(innerNode); // @error
                        };
                    }
                };
            };
        }
    }
}

isolated class TestInvalidTransferOfValuesInAnonFunctionsInIsolatedObject {
    private int[][] arr = [];

    function init(int[] node) {
        function _ = function () {
            lock {
                self.arr.push(node); // @error
            }
        };
    }

    function f1(int[] node) {
        function _ = function () returns int[] {
            lock {
                return self.arr[0]; // @error
            }
        };
    }

    function f2(int[] node) {
        lock {
            function _ = function () {
                object {} _ = isolated object {
                    private int[][] innerArr = [];

                    function innerF(int[] innerNode) {
                        function _ = function () {
                            lock {
                                self.innerArr.push(innerNode); // @error
                            }
                        };
                    }
                };
            };
        }
    }
}

client isolated class TestInvalidAccessOfSelfWithinAnonFunctionInRemoteAndResourceMethods {
    private int[][] arr = [];

    resource function get test() {
        function _ = function (int[] node) {
            self.arr.push(node); // @error
        };
    }

    remote function testFn() {
        function _ = function (int[] node) {
            lock {
                self.arr.push(node); // @error
            }
        };
    }
}

// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/io;

function f1() {
    worker A {
        _ = g1();
    }
}

function g1() returns int {
    return 1;
}

function f2() {
    worker A {
        _ = g1();
    }

    worker B {
        _ = g1();
    }
}

final readonly & string[] globalArr = ["B"];

function f3(string[] & readonly arr) {
    final string a = "A";
    worker A {
        string _ = a + arr[0];
        _ = g1();
    }

    worker B {
        string _ = globalArr[0];
        _ = g1();
    }
}

function f4(string[] & readonly arr) {
    final string a = "A";
    worker A {
        string _ = a + arr[0];
        future<int> _ = start g1();
    }

    worker B {
        string _ = globalArr[0];
        var obj1 = object {
            function f1() returns string {
                return globalArr[0] + a;
            }

            function f2() returns string {
                return "A";
            }
        };
        future<string> _ = start obj1.f1();
        future<string> _ = start obj1.f2();
    }
}

function testIsolationInferenceWithNamedWorkers() {
    assertTrue(<any>f1 is isolated function);
    assertTrue(<any>f2 is isolated function);
    assertTrue(<any>f3 is isolated function);
    assertTrue(<any>f4 is isolated function);
}

function f5() {
    @strand {thread: "parent"}
    worker A {
        _ = g1();
    }
}

function f6() {
    @strand {thread: "any"}
    worker A {
        _ = g1();
    }

    worker B {
        _ = g1();
    }
}

function f7(string[] & readonly arr) {
    final string a = "A";
    worker A {
        string _ = a + arr[0];
        _ = g1();
    }

    @strand {thread: "parent"}
    worker B {
        string _ = globalArr[0];
        _ = g1();
    }
}

function f8(string[] & readonly arr) {
    final string a = "A";

    @strand {thread: "parent"}
    worker A {
        string _ = a + arr[0];
        future<int> _ = start g1();
    }

    worker B {
        string _ = globalArr[0];
        var obj1 = object {
            function f1() returns string {
                return globalArr[0] + a;
            }

            function f2() returns string {
                return "A";
            }
        };
        future<string> _ = start obj1.f1();
        future<string> _ = start obj1.f2();
    }
}

function f9() {
    int[] tt = [];
    worker A {
        future<()> _ = start g2(tt);
    }
}

function f10() {
    int[] tt = [];
    worker A {
        future<()> _ = start g2([1, 2]);
    }

    worker B {
        future<()> _ = start g2(tt);
    }
}

function f11() {
    int[] tt = [];
    fork {
        worker A {
            future<()> _ = start g2([1, 2]);
        }

        worker B {
            future<()> _ = start g2(tt);
        }
    }
}

function g2(int[] arr) {
}

function f12() {
    int[] tt = [];
    worker A {
        future<()> _ = start g3([], tt);
    }
}

function f13() {
    int[] tt = [];
    worker A {
        future<()> _ = start g3([1, 2]);
    }

    worker B {
        future<()> _ = start g3([], tt);
    }
}

function f14() {
    int[] tt = [];
    fork {
        worker A {
            future<()> _ = start g2([1, 2]);
        }

        worker B {
            future<()> _ = start g2(tt);
        }
    }
}

function g3(int[] arr, int[]... v) {
}

isolated client class NonPublicIsolatedClass2 {
    private string str = "hello";

    remote function foo(int[] str) returns int {
        _ = hello();
        future<int> _ = start g1();
        return 1;
    }

    function bar(int[] str, int[]... m) returns int {
        future<int> _ = start g1();
        return 2;
    }
}

function f15() {
    int[] tt = [];
    worker A {
        NonPublicIsolatedClass2 cl = new;
        future<int> _ = start cl->foo(tt);
    }
}

function f16() {
    int[] tt = [];
    worker A {
        NonPublicIsolatedClass2 cl = new;
        future<int> _ = start cl->foo([]);
    }

    worker B {
        NonPublicIsolatedClass2 cl = new;
        future<int> _ = start cl.bar([], tt);
    }
}

function f17() {
    int[] tt = [];
    fork {
        worker A {
            NonPublicIsolatedClass2 cl = new;
            future<int> _ = start cl->foo(tt);
        }

        worker B {
            NonPublicIsolatedClass2 cl = new;
            future<int> _ = start cl.bar([]);
        }
    }
}

function testNonIsolationInferenceWithNamedWorkersWithStrandAnnotation() {
    assertFalse(<any>f5 is isolated function);
    assertFalse(<any>f6 is isolated function);
    assertFalse(<any>f7 is isolated function);
    assertFalse(<any>f8 is isolated function);
    assertFalse(<any>f9 is isolated function);
    assertFalse(<any>f10 is isolated function);
    assertFalse(<any>f11 is isolated function);
    assertFalse(<any>f12 is isolated function);
    assertFalse(<any>f13 is isolated function);
    assertFalse(<any>f14 is isolated function);
    assertFalse(<any>f15 is isolated function);
    assertFalse(<any>f16 is isolated function);
    assertFalse(<any>f17 is isolated function);
}

function hello() returns string => "hello";

string helloGlobString = "hello!";

isolated client class NonPublicIsolatedClass {
    private string str = "hello";

    remote function foo() returns int {
        final string a = "A";
        worker A {
            if a == "A" {
                return;
            }
        }
        return 1;
    }

    function bar(string str) returns string {
        worker B returns string {
            return str;
        }
        return "";
    }
}

final string[] & readonly strArrr = [""];

service class NonPublicServiceClass {
    resource function get foo() {
        worker A {
            _ = hello();
        }
    }

    remote function bar() {
        worker B {
            NonPublicIsolatedClass cl = new;
            _ = cl.bar(strArrr[0]);
        }
    }

    function func(string str) {
        worker C {
            int length = str.length();
        }
    }

    public function func2(string str) {
        worker D {
            int length = str.length();
        }
    }

    function func3(string str) {
        worker E {
            helloGlobString = str;
        }
    }
}

public service class PublicServiceClass {
    resource function get foo() {
        worker A {
            _ = hello();
        }
    }

    remote function bar() {
        worker B {
            NonPublicIsolatedClass cl = new;
            _ = cl.bar(strArrr[0]);
        }
    }

    function func(string str) {
        worker C {
            int length = str.length();
        }
    }

    public function func2(string str) {
        worker D {
            int length = str.length();
        }
    }

    function func3(string str) {
        worker E {
            helloGlobString = str;
        }
    }
}

function testServiceClassMethodIsolationInference() {
    NonPublicIsolatedClass isolatedClient = new;
    assertTrue(isolatedClient is IsolatedRemoteFoo);
    assertTrue(<any>isolatedClient.bar is isolated function);

    NonPublicServiceClass isolatedService = new;
    assertTrue(isolatedService is IsolatedGetFoo);
    assertTrue(isolatedService is IsolatedRemoteBar);
    assertTrue(<any>isolatedService.func is isolated function);
    assertTrue(<any>isolatedService.func2 is isolated function);
    assertFalse(<any>isolatedService.func3 is isolated function);

    PublicServiceClass publicService = new;
    assertFalse(publicService is IsolatedGetFoo);
    assertFalse(publicService is IsolatedRemoteBar);
    assertFalse(<any>publicService.func is isolated function);
    assertFalse(<any>publicService.func2 is isolated function);
    assertFalse(<any>publicService.func3 is isolated function);
}

client class NonPublicNonIsolatedClass {
    remote function foo() {
        worker A {
            NonPublicIsolatedClass cl = new;
            _ = cl.bar(strArrr[0]);
        }
    }

    function bar(string str) returns string => str;
}

public isolated client class PublicIsolatedClass {
    remote function foo() {
        worker A {
            NonPublicIsolatedClass cl = new;
            _ = cl.bar(strArrr[0]);
        }
    }

    function bar(string str) returns string => str;
}

function testClientClassMethodIsolationInference() {
    NonPublicNonIsolatedClass c1 = new;
    NonPublicIsolatedClass c2 = new;
    PublicIsolatedClass c3 = new;

    assertTrue(c1 is IsolatedRemoteFooWithoutParams);
    assertTrue(<any>c1.bar is isolated function);

    assertTrue(c2 is IsolatedRemoteFoo);
    assertTrue(<any>c2.bar is isolated function);

    assertFalse(c3 is IsolatedRemoteFooWithoutParams);
    assertFalse(<any>c3.bar is isolated function);
}

public isolated function f18() returns int {
    return 1;
}

function f19() {
    future<int> _ = start f18();
    final int[] & readonly b = [];

    worker A {
       future<int> _ = start f18();
       int[] t = b;
    }
}

function f20() {
    future<()> _ = start f19();
    final int[] & readonly b = [];

    worker A {
       future<()> _ = start f19();
       int[] t = b;
    }
}

function f21() {
    future<int> _ = start f18();
    int[] b = [];

    worker A {
       future<int> _ = start f18();
       int[] t = b;
    }
}

public function f22() returns int {
    return 1;
}

function f23() {
    future<int> _ = start f18();

    worker A {
       future<int> _ = start f22();
    }
}

public isolated function f24(int[] a) returns int {
    return a[0];
}

int[] intArr = [10];

function f25() {
    future<int> _ = start f18();

    worker A {
       future<int> _ = start f24(intArr);
    }
}

function f26() {
    future<int> _ = start f18();
    final int[] & readonly arr = [];

    worker A {
       future<int> _ = start f24(arr);
    }
}

function f27() {
    future<int> _ = start f24(intArr);

    worker A {
       future<int> _ = start f24([1, 2]);
    }
}

function f28() {
    future<int> _ = start f24([1, 2]);
    final int[] & readonly arr = [];

    worker A {
       future<int> _ = start f24(arr);
    }
}

isolated function f29(int[] a) returns int {
    return a[0];
}

function f30() {
    future<int> _ = start f18();

    worker A {
       future<int> _ = start f29(intArr);
    }
}

function f31() {
    worker A {
       future<int> _ = start f29([1, 2]);
    }

    fork {
        worker B {
            future<int> _ = start f29([1, 2]);
        }

        worker C {
            future<int> _ = start f24([1, 2]);
        }
    }

    future<int> _ = start f18();
}

function f32() {
    worker A {
       future<int> _ = start f29([1, 2]);
    }

    int[] arr = [];

    fork {
        worker B {
            future<int> _ = start f29([1, 2]);
        }

        worker C {
            future<int> _ = start f24(arr);
        }
    }

    future<int> _ = start f18();
}

function f33() {
    worker A {
       future<int> _ = start f29([1, 2]);
    }

    int[] arr = [];

    fork {
        worker B {
            future<int> _ = start f29([1, 2]);
        }

        worker C {
            future<int> _ = start f24([]);
        }
    }

    future<int> _ = start f24(arr);
}

function f34(int[] arr) returns int {
    return arr[0];
}

function f35() {
    worker A {
       future<int> _ = start f34([1, 2]);
    }

    final int[] & readonly arr = [];

    fork {
        worker B {
            future<int> _ = start f34(arr);
        }

        worker C {
            future<int> _ = start f34([]);
        }
    }

    future<int> _ = start f34(arr);
}

function f36() {
    worker A {
       future<int> _ = start f34([1, 2]);
    }

    final int[] & readonly arr = [];

    fork {
        worker B {
            future<int> _ = start f34(arr);
        }

        worker C {
            future<int> _ = start f34([]);
        }
    }

    int[] arr2 = [];
    future<int> _ = start f34(arr2);
}

function testIsolatedInferenceWithWorkersAndStartsCallingPublicIsolatedFunctions() {
    assertTrue(<any>f19 is isolated function);
    assertTrue(<any>f20 is isolated function);
    assertFalse(<any>f21 is isolated function);
    assertFalse(<any>f23 is isolated function);
    assertFalse(<any>f25 is isolated function);
    assertTrue(<any>f26 is isolated function);
    assertFalse(<any>f27 is isolated function);
    assertTrue(<any>f28 is isolated function);
    assertFalse(<any>f30 is isolated function);
    assertTrue(<any>f31 is isolated function);
    assertFalse(<any>f32 is isolated function);
    assertFalse(<any>f33 is isolated function);
    assertTrue(<any>f35 is isolated function);
    assertFalse(<any>f36 is isolated function);
}

final int[] & readonly intArr2 = [];

function f37(int[] b) returns int {
    return b[0];
}

Listener ep = new ();

function init() returns error? {
    return ep.attach(service object {
    resource function get foo() returns int[] {
        final int[] & readonly a = [];
        future<int> _ = start f37(intArr2);

        worker A {
            future<int> _ = start f37(a);
            int[] y = intArr2;
        }

        future<int> _ = start f37(a);

        fork {
            worker B {
                future<int> _ = start f37(intArr2);
                int[] y = a;
            }

            worker C {
                future<int> _ = start f37(a);
                int[] y = a;
            }
        }

        return intArr2;
    }

    resource function get baz() returns int[] {
        final int[] & readonly a = [];
        future<int> _ = start f37(intArr);
        return a;
    }

    resource function get boo() returns int[] {
        final int[] & readonly a = [];
        future<int> _ = start f37(intArr2);

        worker A {
            future<int> _ = start f37(intArr);
            int[] y = a;
        }

        return intArr2;
    }

    remote function bar() returns int[] {
        final int[] & readonly a = [];
        future<int> _ = start f37(intArr2);

        worker A {
            future<int> _ = start f37(a);
            int[] y = intArr2;
        }

        future<int> _ = start f37(a);

        fork {
            worker B {
                future<int> _ = start f37(intArr2);
                int[] y = a;
            }

            worker C {
                future<int> _ = start f37(a);
                int[] y = a;
            }
        }

        return intArr2;
    }

    function bam() returns int[] {
        final int[] & readonly a = [];
        future<int> _ = start f37(intArr2);

        worker A {
            future<int> _ = start f37(a);
            int[] y = intArr2;
        }

        future<int> _ = start f37(a);

        fork {
            worker B {
                future<int> _ = start f37(intArr2);
                int[] y = a;
            }

            worker C {
                future<int> _ = start f37(a);
                int[] y = a;
            }
        }

        return a;
    }
    });
}

type IsolatedRemoteFoo client object {
    isolated remote function foo() returns int;
};

type IsolatedRemoteFooWithoutParams client object {
    isolated remote function foo();
};

type IsolatedGetFoo service object {
    isolated resource function get foo();
};

type IsolatedRemoteBar service object {
    isolated remote function bar();
};

type IsolatedModuleGetFoo service object {
    isolated resource function get foo() returns int[];
};

type IsolatedModuleGetBaz service object {
    isolated resource function get baz() returns int[];
};

type IsolatedModuleGetBoo service object {
    isolated resource function get boo() returns int[];
};

type IsolatedModuleRemoteBar service object {
    isolated remote function bar() returns int[];
};

type IsolatedModuleBam service object {
    isolated function bam() returns int[];
};

class Listener {
    public function attach(service object {} s, string|string[]? name = ()) returns error? {
        assertTrue(s is IsolatedModuleGetFoo);
        assertFalse(s is IsolatedModuleGetBaz);
        assertFalse(s is IsolatedModuleGetBoo);
        assertTrue(s is IsolatedModuleRemoteBar);
        assertTrue(s is IsolatedModuleBam);
    }

    public function detach(service object {} s) returns error? {
    }

    public function 'start() returns error? {
    }

    public function gracefulStop() returns error? {
    }

    public function immediateStop() returns error? {
    }
}

function assertTrue(anydata actual) => assertEquality(true, actual);

function assertFalse(anydata actual) => assertEquality(false, actual);

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }

    panic error(ASSERTION_ERROR_REASON,
                message = "expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}

public function main() {
    if neverPrint() {
        io:println("");
    }
    testIsolationInferenceWithNamedWorkers();
    testNonIsolationInferenceWithNamedWorkersWithStrandAnnotation();
    testServiceClassMethodIsolationInference();
    testClientClassMethodIsolationInference();
    testIsolatedInferenceWithWorkersAndStartsCallingPublicIsolatedFunctions();
}

function neverPrint() returns boolean => false;

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

int[] a = getIntArray();
isolated int[][] b = [a, getIntArray()]; // @error // @error

isolated record {
    int[] i;
    boolean[2] j;
} c = {
    i: a, // @error
    j: getBooleanArray(<int[2]> getIntArray()) // @error
};

isolated object {
    int[] i;
    string[] j;
} d = object { // @error
    int[] i = getIntArray();
    string[] j;

    function init() {
        self.j = [];
    }
};

isolated NonIsolatedObject e = new NonIsolatedClassWithIsolatedInit(getIntArray(), ["hello", "world"]); // @error

int[] x = [1, 2, 3];

function getIntArray() returns int[] => x;

type NonIsolatedObject object {
    int[] i;
    string[] j;
};

class NonIsolatedClassWithIsolatedInit {
    int[] i;
    string[] j;

    isolated function init(int[] i, string[] j) {
        self.i = i;
        self.j = j;
    }
}

isolated function getBooleanArray(int[2] arr) returns boolean[2] {
    return <boolean[2]> arr.'map(intVal => intVal < 0);
}

function testInvalidIsolatedVariableAccessOutsideLock(boolean bool) {
    int[][] arr = b; // @error

    if bool {
        int index = 1;
        int j = arr[0][0];

        while j != 0 {
            c.i = [index]; // @error
            j = arr[index][index];
            index += 1;
        }
    }

    var _ = isolated function() {
        int[][] arr2 = b; // @error // @error
    };
}

isolated class IsolatedObject {
    private map<int> m = {};

    isolated function testInvalidAccessOfMoreThanOneIsolatedVar1() {
        lock {
            int x = b[0][0]; // @error
            self.m["a"] = x; // @error
        }
    }

    function testInvalidAccessOfMoreThanOneIsolatedVar2() {
        lock {
            int x = b[0][0]; // @error
            self.m["a"] = x; // @error
            self.testInvalidAccessOfMoreThanOneIsolatedVar1(); // @error
        }
    }
}

isolated map<boolean>[] f = [];
map<boolean> globBoolMap = {a: true, b: false};

function testInvalidCopyInWithIsolatedVarAccessOne(map<boolean> boolMap) {
    map<boolean> bm1 = {};
    lock {
        map<boolean> bm2 = {a: true, b: false};
        f[0] = globBoolMap; // @error
        f.push(boolMap); // @error
        f = [bm1, bm2]; // @error // @error // @error
    }
}

isolated function testInvalidCopyInWithIsolatedVarAccessTwo(map<boolean> boolMap) {
    map<boolean> bm1 = {};
    lock {
        map<boolean> bm2 = {};
        lock {
            map<boolean> bm3 = boolMap; // @error
            bm2 = bm3; // @error
        }

        f.push(boolMap); // @error
        f[0] = boolMap; // @error
        f = [bm1, bm2]; // @error // @error // @error
        bm1 = f[0]; // @error
    }
}

function testInvalidCopyOutWithIsolatedVarOne(map<boolean>[] boolMaps) returns map<boolean>[] {
    map<boolean>[] bm1 = boolMaps; // @error
    lock {
        map<boolean>[] bm2 = [{a: true, b: false}];
        bm2 = f.clone();
        f = bm2; // @error
        return bm2; // @error
    }
}

isolated function testIInvalidCopyOutWithIsolatedVarTwo(map<boolean>[] boolMaps) {
    map<boolean> bm1 = {}; // @error
    lock {
        map<boolean> bm2 = {}; // @error
        lock {
            map<boolean> bm3 = boolMaps[0].clone();
            bm1 = bm3; // @error
            _ = nonIsolatedFunc(); // @error // @error
        }
        f = boolMaps; // @error // @error
    }
}

function testInvokingNonIsolatedFunctionInLockAccessingIsolatedVar() {
    lock {
        f = [];
        _ = nonIsolatedFunc(); // @error
    }
}

isolated int g = 1;

isolated function testAccessingDifferentIsolatedVarsInNestedLockStatements() {
    lock {
        lock {
            int i = g; // @error // @error
        }

        int j = 2; // @error
        f = []; // @error
    }
}

function nonIsolatedFunc() returns int[] {
    return [1, 2, 3];
}

isolated int[] stack = [];

int[][] allStacks = [];

function testInvalidTransferOutInLockAccessingIsolatedVar() {
    lock {
        int[][] stacks = [stack]; // OK
        allStacks = stacks; // error // @error
    }
}

isolated int[][] isolatedStacks = [];

function testInvalidTransferInUpdatingIsolatedVar(int[] n) {
    lock {
        isolatedStacks.push(n); // error for `n`, OK if it was `n.clone()` // @error
    }
}

isolated function testInvalidTransferOutUpdatingOfIsolatedVar() returns int[][] {
    lock {
        return isolatedStacks; // error, OK if it was `isolatedStacks.clone()` // @error
    }
}

isolated function testInvalidTransferOutUpdatingOfIsolatedVarMember(int index) returns int[] {
    lock {
        return isolatedStacks[index]; // error, OK if it was `isolatedStacks[index].clone()` or ` isolatedStacks.clone()[index]` // @error
    }
}

function testInvalidTransferInAsArgInLockAccessingIsolatedVar(int[] n) {
    lock {
        update(isolatedStacks, n); // error, OK if `update(isolatedStacks, n.clone())` // @error
    }
}

isolated function update(int[][] x, int[] y) {
    x.push(y);
}

isolated int[][] arr = [];

function getArrayMemberDirect() returns int[] {
    lock {
        return arr[0]; // @error
    }
}

function getArrayMemberViaFunctionCall() returns int[] {
    lock {
        return getMember(arr); // @error
    }
}

isolated function getMember(int[][] x) returns int[] {
    return x[0];
}

isolated map<int[]> mp = {};

function getMapMemberDirect() returns int[] {
    lock {
        if true {
            return <int[]> mp["x"]; // @error
        } else {
            return mp.get("x"); // @error // @error
        }
    }
}

function getMapMemberViaFunctionCall() returns int[] {
    lock {
        return getMapMember(mp); // @error
    }
}

isolated function getMapMember(map<int[]> mp) returns int[] {
    return <int[]> mp["a"];
}

function getArrayMemberViaFunctionCall2() returns int[] {
    lock {
        int[][] arr2 = [arr[0]];
        return getMember(arr2); // @error
    }
}

function getMapMemberViaFunctionCall2() returns int[] {
    lock {
        map<int[]> mp2 = {x: arr[0]};
        return getMapMember(mp2); // @error
    }
}

class NonIsolatedClass {
    int[] m = [];

    isolated function getMember() {
        lock {
            arr[0] = self.m; // @error
            arr.push(self.m); // @error
        }
    }

    isolated function getMember2() returns int[] {
        lock {
            arr[0] = self.getMemberInternal(); // @error
            return getMemberUsingSelf(self); // @error // @error
        }
    }

    isolated function getMemberInternal() returns int[] {
        return self.m;
    }
}

isolated function getMemberUsingSelf(NonIsolatedClass cl) returns int[] => cl.getMemberInternal();

isolated map<int> isolatedModuleLevelMap = {};

isolated function invalidCopyInInMethodCall1() returns map<int>[] {
    map<int>[] y = [];

    lock {
        y[0] = isolatedModuleLevelMap; // @error
        y.push(isolatedModuleLevelMap); // @error
        array:push(y, isolatedModuleLevelMap); // @error
        return y; // @error // @error
    }
}

function invalidCopyInInMethodCall2(map<int[]> y) {
    lock {
        _ = y.remove(isolatedModuleLevelMap["a"].toString()); // @error
    }
}

function invalidCopyOutAccessingIsolatedVar() returns map<int>[] {
    map<int>[] y = [];
    map<int> z; // @error
    lock {
        map<int>[] y2 = [];
        y[0] = isolatedModuleLevelMap; // @error
        z = isolatedModuleLevelMap; // @error
        return y2; // @error
    }
}

isolated isolated object {}[] isolatedIsolatedObjArr = [];

isolated function getArr() returns isolated object {}[] {
    lock {
        return from var ob in isolatedIsolatedObjArr select ob; // @error
    }
}

isolated int[] i = [1, 2];

isolated function testIsolationAnalysisWithOnFailStatementNegative() {
    do {

    } on fail error e { // @error
        int k = i.pop(); // @error // @error
    }

    anydata l = 1;
    match l {
        "1" => {
            lock {
                int k = check int:fromString(l.toString()) + i[0]; // @error
            }
        }
    } on fail var e {
        i.push(e.message().length()); // @error
    }

    foreach var item in 1 ..< 2 {

    } on fail error e { // @error
        i.push(1); // @error
    }

    int m = 1;

    while m < 2 {
        m += 1;
    } on fail error e { // @error
        i.push(m); // @error
    }

    lock {

    } on fail error e { // @error
        i[i.length()] = 1; // @error // @error
    }
}

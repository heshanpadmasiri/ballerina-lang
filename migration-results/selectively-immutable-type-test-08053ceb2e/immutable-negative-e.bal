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

type Person record {
    PersonalDetails details;
    Person employer?;
    int id;
};

type PersonalDetails record {
    string name;
    int yob;
};

type Student record {|
    PersonalDetails details;
|};

function testReadOnlyPropagationForNestedTypes() {
    readonly & Person p = {
        details: {
            name: "Jo",
            yob: 1990
        },
        id: 1234
    };

    Student w = p; // @error
    int|string x = p.details; // @error
    Student y = p?.employer; // @error
    string z = p["id"]; // @error
}

function testNonReadOnlyValueForReadOnlyCET() {
    PersonalDetails d = {
        name: "May",
        yob: 1992
    };

    Student st = {
        details: d
    };

    Student & readonly rst = st; // @error

    Person & readonly p = {
        details: d, // @error
        id: 1234
    };
}

type AB "A"|"B";

class Obj {
    int i;

    function init(int i) {
        self.i = i;
    }
}

type ABAny AB|any;

function testInvalidAssignmentToWideReadOnlyIntersection() {
    ABAny & readonly w = new Obj(1); // @error

    string[] arr = ["foo"];
    anydata & readonly x = arr; // @error

    any & readonly y = start testInvalidReaoOnlyRecordInit(); // @error

    (Obj|int[]|future<int>) & readonly z = arr; // @error
}

type Employee record {|
    readonly PersonalDetails details;
    Department & readonly dept;
|};

type Department record {|
    string name;
|};

function testInvalidReaoOnlyRecordInit() {
    PersonalDetails details = {
        name: "Anne",
        yob: 1995
    };

    record {
        Department dept;
    } rec = {
        dept: {
            name: "finance"
        }
    };

    Employee e = {
        details: details, // @error
        ...rec // @error
    };
}

function testInvalidReaoOnlyRecordFieldUpdates() {
    PersonalDetails & readonly details = {
        name: "Anne",
        yob: 1995
    };

    record {
        Department dept;
    } & readonly rec = {
        dept: {
            name: "finance"
        }
    };

    Employee e = {
        details: details,
        ...rec // @error
    };

    e.details = { // @error
        name: "May",
        yob: 1992
    };
    e["details"]["year"] = 1990; // @error

    Department dept2 = {
        name: "IT"
    };
    e.dept = dept2; // @error
    e["dept"] = dept2; // @error
}

class Foo {
    stream<int> ft = (<int[]> [1, 2, 3]).toStream();
}

type Bar record {|
    readonly string name;
    Foo id;
|};

function testInvalidNeverReadOnlyConstraint() {
    table<Bar> key(name) & readonly tb = table [ // @error
        {name: "Jo", id: new} // @error
    ];
}

type Baz object {
    future<()> ft;

    function getFt();
};

function testNeverReadOnlyObject() {
    Baz & readonly bz; // @error
}

type Config object {
    string name;

    function getName() returns string;
};

readonly class MyConfig {
    final string name;

    public function init(string name) {
        self.name = name;
    }

    function getName() returns string {
        return self.name;
    }
}

function testInvalidObjectUpdate() {
    Config & readonly config = new MyConfig("client config");
    config.name = "new name"; // @error

    MyConfig myConfig = new MyConfig("client config");
    myConfig.name = "new name"; // @error
}

type ABC record {|
    DEF & readonly d; // @error
|};

type DEF record {|
    future<int> fr;
|};

class GHI {
    JKL & readonly j; // @error

    function init(JKL & readonly j) { // @error
        self.j = j;
    }
}

type JKL object {
    future<int> fr;
};

function testInvalidMemberWithConstructorReadOnlyCast() {
    int[] w = [1, 2];
    int[] x = [];

    record {|int[]...;|} y = {
        "c": [56, 78, 4456]
    };

    map<int[]> z = <readonly> {
        a: [22, 12123],
        b: w, // @error
        x, // @error
        ...y // @error
    };
}

function testInvalidValueForEffectiveReadOnlyCast() {
    future<int> f = start getInt();
    NeverImmutable|map<int> w = <readonly> {x: f}; // @error

    float[] a = [11.2, 12.122];
    stream<float> str = a.toStream();
    string[]|stream<float>[] x = <readonly> [str, a.toStream()]; // @error

    NeverImmutable ni = <readonly> {x: f}; // @error
}

type NeverImmutable record {
    future<int> x;
};

function getInt() returns int => 1;

readonly class ReadOnlyClass {
    int j = 3;
}

function testInvalidUpdateOfAnonTypeField() {
    readonly & record {int i;} x = {i: 1};
    x.i = 2; // error // @error

    readonly & object {int j;} y = new ReadOnlyClass();
    y.j = 4; // error // @error
}

class NeverReadOnlyClass {
    future<int> ft;

    function init(future<int> ft) {
        self.ft = ft;
    }
}

function testNeverReadOnlyClassIntersectionWithReadOnly() {
    var func = function () returns int => 1;
    future<int> ft = start func();
    readonly & NeverReadOnlyClass nrc = new (ft); // @error
}

ReadOnlyClass & readonly rr1 = new; // @error

function testInvalidInitializationOfReadOnlyClassIntersectionWithReadOnly() {
    ReadOnlyClass & readonly rr2 = new; // @error
}

class NonReadOnlyClass {
    int j = 3;
}

NonReadOnlyClass & readonly nr1 = new; // @error

function testInvalidInitializationOfNonReadOnlyClassIntersectionWithReadOnly() {
    NonReadOnlyClass & readonly nr2 = new; // @error
}

function testNonReadOnlyAssignmentToReadOnlyAndClassIntersection() {
    NonReadOnlyClass nrc = new;

    ReadOnlyClass & readonly r1 = nrc; // @error
    NonReadOnlyClass & readonly r2 = nrc; // @error
}

function testInvalidUsageOfReadOnlyIntersectionWithNever() {
    never & readonly a; // @error

    record { never i?; int j; } & readonly b = {i: 1, j: 1, "k": "str"}; // @error
}

type Grault record {
    stream<int>|never x;
};

function testNeverReadOnlyIntersectionWithNeverExplicitlyInType() {
    Grault & readonly y; // @error
}

type R1 record {
    stream<int> a?;
};

function testReadOnlyIntersectionWithRecordThatHasAnOptionalNeverReadOnlyFieldNegative() {
    R1 & readonly a = {a: new stream<int>(), "b": 1}; // @error
    record {| never a?; |} _ = a; // @error
}

type R2 record {|
    int a;
    stream<int>...;
|};

function testReadOnlyIntersectionWithRecordThatHasANeverReadOnlyRestFieldNegative() {
    R2 & readonly a = {a: 1, "b": 1, "c": new stream<int>()}; // @error
    record {| never a?; |} _ = a; // @error
    R2 & readonly _ = {"b": 1}; // @error
}

type R3 record {
    stream<int> a;
};

type R4 record {
    stream<int> a = new;
};

function testReadOnlyIntersectionWithRecordThatHasARequiredNeverReadOnlyFieldNegative() {
    (R3 & readonly)? _ = (); // @error
    R4 & readonly _ = {}; // @error
}

type ImmutableXmlElement xml:Element & readonly;

function testTypeDefinitionForReadOnlyIntersectionWithBuiltinTypeNegative() {
    ImmutableXmlElement _ = xml `text`; // error incompatible types: expected 'ImmutableXmlElement', found 'xml:Text' // @error

    xml:Element a = xml `<foo/>`;
    ImmutableXmlElement _ = a; // incompatible types: expected 'ImmutableXmlElement', found 'xml:Element' // @error

    ImmutableXmlElement b = xml `<bar/>`;
    xml:Element & readonly c = xml `<baz/>`;

    map<xml:Text|ImmutableXmlElement> _ = {
        w: c, // OK
        x: xml ``, // OK
        y: a, // error incompatible types: expected '(xml:Text|ImmutableXmlElement)', found 'xml:Element' // @error
        z: b // OK
    };
}

type MyJson int|float|decimal|boolean|string|()|map<MyJson>|MyJson[];

function testReadOnlyIntersectionWithJsonAndAnydataNegative() {
    anydata & readonly a = 1;
    string|error b = a; // error // @error

    json & readonly c = 1;
    string|error d = c; // error // @error

    any|error e = a; // OK
    any|error f = c; // OK

    anydata & readonly _ = a; // OK
    json & readonly _ = c; // OK

    anydata & readonly _ = c; // OK
    json & readonly _ = a; // error // @error

    MyJson & readonly g = 1;
    json & readonly h = 1;

    json _ = g; // OK
    MyJson _ = h; // OK
    json & readonly _ = g; // OK
    MyJson & readonly _ = h; // OK
    (json & readonly)|xml _ = g; // OK
    xml|(MyJson & readonly) _ = h; // OK

    json i = 1;
    MyJson j = 1;
    MyJson _ = i; // OK
    json _ = j; // OK

    (json & readonly)[] k = [];
    MyJson[] l = k; // OK
    (json & readonly)[] _ = l; // error // @error
    json[] m = l; // OK
    (MyJson & readonly)[] _ = m; // error // @error

    (xml & readonly)[] n = k; // error // @error
    (json & readonly)[] _ = n; // error // @error
}

function testUnsupportedIntersectionWithReadonly(stream<int> strm) {
    (stream<int>|string:RegExp) & readonly _ = strm; // @error
}

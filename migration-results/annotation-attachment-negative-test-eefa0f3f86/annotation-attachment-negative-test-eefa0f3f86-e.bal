// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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



type Annot record {
    string val;
};

public annotation Annot v1 on type;
annotation Annot v2 on class;
public annotation Annot v3 on function;
annotation map<int> v4 on object function;
public annotation Annot v5 on object function;
annotation Annot v6 on parameter;
public annotation v7 on return;
annotation Annot v8 on service;

public const annotation map<string> v9 on source listener;
const annotation map<string> v10 on source annotation;
const annotation map<int> v11 on source var;
public const annotation map<string> v12 on source const;
const annotation map<string> v13 on source external;
const annotation map<boolean> v15 on source worker;

@v2 { // @error
    val: "v2"
}
@v3 { // @error
    val: "v3"
}
@v4 { // @error
    val: 4
}
@v5 { // @error
    val: "v5"
}
@v6 { // @error
    val: "v6"
}
@v7 // @error
@v8 { // @error
    val: "v8"
}
@v9 { // @error
    val: "v9"
}
@v10 { // @error
    val: "v10"
}
@v11 { // @error
    val: 11
}
@v12 { // @error
    val: "v12"
}
@v13 { // @error
    val: "v13"
}
@v15 { // @error
    val: false
}
public type T1 record {
    string name;
};

@v3 { // @error
    val: "v3"
}
@v4 { // @error
    val: 4
}
@v5 { // @error
    val: "v5"
}
@v6 { // @error
    val: "v6"
}
@v7 // @error
@v8 { // @error
    val: "v8"
}
@v9 { // @error
    val: "v9"
}
@v10 { // @error
    val: "v10"
}
@v11 { // @error
    val: 11
}
@v12 { // @error
    val: "v12"
}
@v13 { // @error
    val: "v13"
}
@v15 { // @error
    val: false
}
class T2 {
    string name = "ballerina";

    @v1 { // @error
        val: "v1"
    }
    @v2 { // @error
        val: "v2"
    }
    @v5 {
        val: "v5"
    }
    @v6 { // @error
        val: "v6"
    }
    @v7 // @error
    @v8 { // @error
        val: "v8"
    }
    @v9 { // @error
        val: "v9"
    }
    @v10 { // @error
        val: "v10"
    }
    @v11 { // @error
        val: 11
    }
    @v12 { // @error
        val: "v12"
    }
    @v13 { // @error
        val: "v13"
    }
    @v15 { // @error
        val: false
    }
    public function setName(string name) {
        self.name = name;
    }

    @v1 { // @error
        val: "v1"
    }
    @v2 { // @error
        val: "v2"
    }
    @v5 {
        val: "v5"
    }
    @v6 { // @error
        val: "v6"
    }
    @v7 // @error
    @v8 { // @error
        val: "v8"
    }
    @v9 { // @error
        val: "v9"
    }
    @v10 { // @error
        val: "v10"
    }
    @v11 { // @error
        val: 11
    }
    @v12 { // @error
        val: "v12"
    }
    @v13 { // @error
        val: "v13"
    }
    @v15 { // @error
        val: false
    }
    public function getName() returns string { return self.name; }
}

@v1 { // @error
    val: "v1"
}
@v2 { // @error
    val: "v2"
}
@v4 { // @error
    val: 4
}
@v5 { // @error
    val: "v5"
}
@v6 { // @error
    val: "v6"
}
@v7 // @error
@v8 { // @error
    val: "v8"
}
@v9 { // @error
    val: "v9"
}
@v10 { // @error
    val: "v10"
}
@v11 { // @error
    val: 11
}
@v12 { // @error
    val: "v12"
}
@v13 { // @error
    val: "v13"
}
@v15 { // @error
    val: false
}
public function func() returns int {
    return 1;
}

public function funcWithParam(@v1 { // @error
                                val: "v1"
                            }
                            @v2 { // @error
                                val: "v2"
                            }
                            @v3 { // @error
                                val: "v2"
                            }
                            @v4 { // @error
                                val: 4
                            }
                            @v5 { // @error
                                val: "v5"
                            }
                            @v7 // @error
                            @v8 { // @error
                                val: "v8"
                            }
                            @v9 { // @error
                                val: "v9"
                            }
                            @v10 { // @error
                                val: "v10"
                            }
                            @v11 { // @error
                                val: 11
                            }
                            @v12 { // @error
                                val: "v12"
                            }
                            @v13 { // @error
                                val: "v13"
                            }
                            @v15 { // @error
                                val: false
                            } string param) returns @v1 { // @error
                                                        val: "v1"
                                                    }
                                                    @v2 { // @error
                                                        val: "v2"
                                                    }
                                                    @v3 { // @error
                                                        val: "v2"
                                                    }
                                                    @v4 { // @error
                                                        val: 4
                                                    }
                                                    @v5 { // @error
                                                        val: "v5"
                                                    }
                                                    @v6 { // @error
                                                        val: "v6"
                                                    }
                                                    @v8 { // @error
                                                        val: "v8"
                                                    }
                                                    @v9 { // @error
                                                        val: "v9"
                                                    }
                                                    @v10 { // @error
                                                        val: "v10"
                                                    }
                                                    @v11 { // @error
                                                        val: 11
                                                    }
                                                    @v12 { // @error
                                                        val: "v12"
                                                    }
                                                    @v13 { // @error
                                                        val: "v13"
                                                    }
                                                    @v15 { // @error
                                                        val: false
                                                    } int {
    return 1;
}

@v1 { // @error
    val: "v1"
}
@v2 { // @error
    val: "v2"
}
@v3 { // @error
    val: "v3"
}
@v4 { // @error
    val: 4
}
@v5 { // @error
    val: "v5"
}
@v6 { // @error
    val: "v6"
}
@v7 // @error
@v8 { // @error
    val: "v8"
}
@v10 { // @error
    val: "v10"
}
@v11 { // @error
    val: 11
}
@v12 { // @error
    val: "v12"
}
@v13 { // @error
    val: "v13"
}
@v15 { // @error
    val: false
}
listener Listener lis = new;

@v1 { // @error
    val: "v1"
}
@v2 { // @error
    val: "v2"
}
@v3 { // @error
    val: "v3"
}
@v4 { // @error
    val: 4
}
@v5 { // @error
    val: "v5"
}
@v6 { // @error
    val: "v6"
}
@v7 // @error
@v9 { // @error
    val: "v9"
}
@v10 { // @error
    val: "v10"
}
@v11 { // @error
    val: 11
}
@v12 { // @error
    val: "v12"
}
@v13 { // @error
    val: "v13"
}
@v15 { // @error
    val: false
}
service on lis {

    @v1 { // @error
        val: "v1"
    }
    @v2 { // @error
        val: "v2"
    }
    @v4 {
        val: 4
    }
    @v6 { // @error
        val: "v6"
    }
    @v7 // @error
    @v8 { // @error
        val: "v8"
    }
    @v9 { // @error
        val: "v9"
    }
    @v10 { // @error
        val: "v10"
    }
    @v11 { // @error
        val: 11
    }
    @v12 { // @error
        val: "v12"
    }
    @v13 { // @error
        val: "v13"
    }
    @v15 { // @error
        val: false
    }
    resource function get res() {

    }
}

class Listener {


    public function init() {
    }

    public function attach(service object {} s, string[]|string? name = ()) returns error? {
    }

    public function detach(service object {} s) returns error? {
    }

    public function 'start() returns error? {
    }

    public function gracefulStop() returns error? {
        return ();
    }

    public function immediateStop() returns error? {
        return ();
    }
}

@v1 { // @error
    val: "v1"
}
@v2 { // @error
    val: "v2"
}
@v3 { // @error
    val: "v3"
}
@v4 { // @error
    val: 4
}
@v5 { // @error
    val: "v5"
}
@v6 { // @error
    val: "v6"
}
@v7 // @error
@v8 { // @error
    val: "v8"
}
@v9 { // @error
    val: "v9"
}
@v11 { // @error
    val: 11
}
@v12 { // @error
    val: "v12"
}
@v13 { // @error
    val: "v13"
}
@v15 { // @error
    val: false
}
const annotation map<string> v14 on source annotation;

@v1 { // @error
    val: "v1"
}
@v2 { // @error
    val: "v2"
}
@v3 { // @error
    val: "v3"
}
@v4 { // @error
    val: 4
}
@v5 { // @error
    val: "v5"
}
@v6 { // @error
    val: "v6"
}
@v7 // @error
@v8 { // @error
    val: "v8"
}
@v9 { // @error
    val: "v9"
}
@v10 { // @error
    val: "v10"
}
@v12 { // @error
    val: "v12"
}
@v13 { // @error
    val: "v13"
}
@v15 { // @error
    val: false
}
int i = 12;

int b = let @v1 { // @error
                val: "v1"
            }
            @v2 { // @error
                val: "v2"
            }
            @v3 { // @error
                val: "v3"
            }
            @v4 { // @error
                val: 4
            }
            @v5 { // @error
                val: "v5"
            }
            @v6 { // @error
                val: "v6"
            }
            @v7 // @error
            @v8 { // @error
                val: "v8"
            }
            @v9 { // @error
                val: "v9"
            }
            @v10 { // @error
                val: "v10"
            }
            @v12 { // @error
                val: "v12"
            }
            @v13 { // @error
                val: "v13"
            }
            @v15 { // @error
                val: false
            } int x = 4 in 2 * x;

@v1 { // @error
    val: "v1"
}
@v2 { // @error
    val: "v2"
}
@v3 { // @error
    val: "v3"
}
@v4 { // @error
    val: 4
}
@v5 { // @error
    val: "v5"
}
@v6 { // @error
    val: "v6"
}
@v7 // @error
@v8 { // @error
    val: "v8"
}
@v9 { // @error
    val: "v9"
}
@v10 { // @error
    val: "v10"
}
@v11 { // @error
    val: 11
}
@v13 { // @error
    val: "v13"
}
@v15 { // @error
    val: false
}
const f = 123.4;

function externalFunctionOne(int fi, float ff) returns int = @v1 { // @error
                                                                val: "v1"
                                                            }
                                                            @v2 { // @error
                                                                val: "v2"
                                                            }
                                                            @v3 { // @error
                                                                val: "v3"
                                                            }
                                                            @v4 { // @error
                                                                val: 4
                                                            }
                                                            @v5 { // @error
                                                                val: "v5"
                                                            }
                                                            @v6 { // @error
                                                                val: "v6"
                                                            }
                                                            @v7 // @error
                                                            @v8 { // @error
                                                                val: "v8"
                                                            }
                                                            @v9 { // @error
                                                                val: "v9"
                                                            }
                                                            @v10 { // @error
                                                                val: "v10"
                                                            }
                                                            @v11 { // @error
                                                                val: 11
                                                            }
                                                            @v12 { // @error
                                                                val: "v12"
                                                            }
                                                            @v15 { // @error
                                                                val: false
                                                            } external;

@v8 { // @error
    val: "invalid"
}
service object {} serVar =
@v1 { // @error
    val: "v1"
}
@v2 { // @error
    val: "v2"
}
@v3 { // @error
    val: "v3"
}
@v4 { // @error
    val: 4
}
@v5 { // @error
    val: "v5"
}
@v6 { // @error
    val: "v6"
}
@v7 // @error
@v9 { // @error
    val: "v9"
}
@v10 { // @error
    val: "v10"
}
@v11 { // @error
    val: 11
}
@v12 { // @error
    val: "v12"
}
@v13 { // @error
    val: "v13"
}
@v15 { // @error
    val: false
}
service object {

    resource function get res() {

    }
};

function funcWithWorker() {

    @v1 { // @error
        val: "v1"
    }
    @v2 { // @error
        val: "v2"
    }
    @v3 { // @error
        val: "v3"
    }
    @v4 { // @error
        val: 4
    }
    @v5 { // @error
        val: "v5"
    }
    @v6 { // @error
        val: "v6"
    }
    @v7 // @error
    @v8 { // @error
        val: "v8"
    }
    @v9 { // @error
        val: "v9"
    }
    @v10 { // @error
        val: "v10"
    }
    @v11 { // @error
        val: 11
    }
    @v12 { // @error
        val: "v12"
    }
    @v13 { // @error
        val: "v13"
    }
    worker w1 {
        // do nothing
    }
}

function loo() {
    future<()> fn =
    @v1 { // @error
        val: "v1"
    }
    @v2 { // @error
        val: "v2"
    }
    @v3 { // @error
        val: "v3"
    }
    @v4 { // @error
        val: 4
    }
    @v5 { // @error
        val: "v5"
    }
    @v6 { // @error
        val: "v6"
    }
    @v7 // @error
    @v8 { // @error
        val: "v8"
    }
    @v9 { // @error
        val: "v9"
    }
    @v10 { // @error
        val: "v10"
    }
    @v11 { // @error
        val: 11
    }
    @v12 { // @error
        val: "v12"
    }
    @v13 { // @error
        val: "v13"
    }
    start funcWithWorker();
}

public annotation v16 on field;
annotation map<int> v17 on object field;
const annotation v18 on source record field;

@v16 int glob = 1; // @error

@v16 // @error
@v17 {} // @error
@v18 // @error
function func2() {

}

@v16 // @error
@v17 {i: 1} // @error
@v18 // @error
type Foo record {
    @v17 {} int i; // @error
};

@v16 // @error
@v17 {i: 1} // @error
@v18 // @error
class Bar {
    @v18 string s = "str"; // @error
}

public const annotation v19 on source type;

function typeConversionExpressionUserFunc() {
    string s = "hello";
    string k = <@v19> s;
    string j = <@v16> s; // @error
}

public const annotation v20 on class;

@v20 @v19 class cls { // @error
    int i;
    function init() {
        self.i = 2;
    }
}

@tainted // @error
class MyClass {
}


@tainted { // @error
}
type MyObject object {
};

function myFunction() returns @v7 {} string => "hello"; // @error

@v1 // @error
type MyType int|string;

@v3 // @error
function myFunction1(@v6 string name) returns string { // @error
    return "Hello " + name;
}

annotation Annot[] v21 on function;

@v21 // @error
@v21 // @error
public function myFunction6(string... argv) {
}

@tainted // @error
@tainted
@v1 {val: "one"} // @error
@v1 {val: "two"}
type MyTypeTwo int|boolean;

@v1 { // @error
    val: "one"
}
@v2 {
    val: "v2"
}
@v3 { // @error
    val: "v3"
}
@v4 { // @error
    val: 4
}
@v5 { // @error
    val: "v5"
}
@v6 { // @error
    val: "v6"
}
@v7 // @error
@v8 { // @error
    val: "v8"
}
@v9 { // @error
    val: "v9"
}
@v10 { // @error
    val: "v10"
}
@v11 { // @error
    val: 11
}
@v12 { // @error
    val: "v12"
}
@v13 { // @error
    val: "v13"
}
@v15 { // @error
    val: false
}
service class ServiceClass {

}

public annotation v22 on type;
public const annotation v23 on source const;
public annotation v24 on class;

@v23 // error // @error
public enum Color1 {
    RED,
    BLUE
}

@v22
@v23 // error // @error
public enum Color2 {
    RED,
    BLUE
}

@v23 // error // @error
@v24 // error // @error
public enum Color3 {
    RED,
    BLUE
}

@v23 // error // @error
public enum Color4 {
    @v23
    WHITE,
    YELLOW
}

@v23 // error // @error
public enum Color5 {
    @v22 // error // @error
    ORANGE,
    GREEN
}

public const annotation record {| int increment; |} v25 on source type;

int x = 1;

@v25 {
    increment: x + 1 // @error
}
type F1 record {|
    int x;
|};

@v25 {
    increment: -x // @error
}
type F2 record {|
    int x;
|};

@v25 {
    increment: 1 + 2 // @error
}
type F3 record {|
    int x;
|};

const int y = 3;

@v25 {
    increment: y + 1 // @error
}
type F4 record {|
    int x;
|};

@v25 {
    increment: y + x // @error
}
type F5 record {|
    int x;
|};

type Person record {|
    string fname;
    string lname;
|};

function getPerson() returns Person {
    Person person = {fname: "Anne", lname: "Frank"};
    return person;
}

[@UndefinedAnnotation int, int] [f1, s2] = [1, 2]; // @error

record {|@UndefinedAnnotation string fname; string lname;|} {fname, lname} = getPerson(); // @error

error<record {|@UndefinedAnnotation int i;|}> err = error("err", i = 33); // @error

error<map<[@UndefinedAnnotation int]>> error () = error("err"); // @error

error<record {|@UndefinedAnnotation int x = 10;|}> error () = error("err"); // @error

function testInvalidAnnotationAttachmentsOnMembersOfStructuredTypedBindingPatterns() {
    [@UndefinedAnnotation int, int] [first, second] = [1, 2]; // @error
    [@UndefinedAnnotation int, int, int] [a, b, c] = [1, 2, 3]; // @error
    [[@UndefinedAnnotation int, int], int] [[a1, b1], c1] = [[1, 2], 3]; // @error
    record {|@UndefinedAnnotation string fname; string lname;|} {fname, lname} = getPerson(); // @error
    error<record {|@UndefinedAnnotation int i;|}> err = error("err", i = 33); // @error
    error<map<[@UndefinedAnnotation int]>> error () = error("err"); // @error
    error<record {|@UndefinedAnnotation int x = 10;|}> error () = error("err"); // @error
}

public annotation v26 on service remote function;

service class ServiceClass2 {
    string name = "ballerina";

    @v1 { // @error
        val: "v1"
    }
    @v2 { // @error
        val: "v2"
    }
    @v3 { // OK
        val: "v3"
    }
    @v4 { // OK
        x: 1
    }
    @v5 { // OK
        val: "v5"
    }
    @v6 { // @error
        val: "v6"
    }
    @v7 // @error
    @v8 { // @error
        val: "v8"
    }
    @v9 { // @error
        val: "v9"
    }
    @v10 { // @error
        val: "v10"
    }
    @v11 { // @error
        val: 11
    }
    @v12 { // @error
        val: "v12"
    }
    @v13 { // @error
        val: "v13"
    }
    @v15 { // @error
        val: false
    }
    remote function getName() returns string { return self.name; }

    @v26 // @error
    resource function get name() returns string { return self.name; }

    @v26 // @error
    function getFirstName() returns string { return self.name; }
}

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
client class MyClient {
    resource function get .() returns int {
        return 3;
    }

    resource function post .() returns int {
        return 2;
    }

    resource function value .(int a = 10) returns int {
            return a;
    }

    resource function value1 .(int a = 10, int b = 20) returns int {
            return a + b;
    }

    resource function value2 .(int a = 10, int b = 20, int c = b) returns int {
                return a + b + c;
    }

    resource function get books/names() returns string[2] {
        return ["book1", "book2"];
    }

    function get() returns int {
        return 0;
    }
}

function testBasicClientResourceAccess() {
    MyClient myClient = new;

    int a = myClient->/;
    assertEquality(a, 3);
    io:println(a); // @output 3
    int b = myClient->/.get;
    assertEquality(b, 3);
    io:println(b); // @output 3
    int b1 = myClient->/.post;
    assertEquality(b1, 2);
    io:println(b1); // @output 2
    int b2 = myClient->/.value();
    assertEquality(b2, 10);
    io:println(b2); // @output 10
    int b3 = myClient->/.value1();
    assertEquality(b3, 30);
    io:println(b3); // @output 30
    int b4 = myClient->/.value1(15);
    assertEquality(b4, 35);
    io:println(b4); // @output 35
    int b5 = myClient->/.value2();
    assertEquality(b5, 50);
    io:println(b5); // @output 50
    int c = myClient->/.get();
    assertEquality(c, 3);
    io:println(c); // @output 3
    string[2] d = myClient->/books/names;
    assertEquality(d, <string[2]>["book1", "book2"]);
    io:println(d); // @output ["book1","book2"]
    string[2] e = myClient->/books/names.get;
    assertEquality(e, <string[2]>["book1", "book2"]);
    io:println(e); // @output ["book1","book2"]
    string[2] f = myClient->/books/names.get();
    assertEquality(f, <string[2]>["book1", "book2"]);
    io:println(f); // @output ["book1","book2"]
}

client class MyClient2 {
    resource function get books/names() returns string[2] {
        return ["book1", "book2"];
    }

    resource function get books/[int id]() returns string {
        return "book" + id.toString();
    }

    resource function get books/[string name]/[float volume]() returns string {
        return name + "." + volume.toString();
    }

    resource function post books/[string name]/[decimal volume]() returns string {
        return name + "." + volume.toString();
    }

    resource function get [boolean flag]() returns boolean {
        return flag;
    }
}

function testClientResourceAccessContainingComputedResourceAccessSegments() {
    MyClient2 myClient = new;
    "books" books = "books";

    string[2] a1 = myClient->/[books]/["names"];
    assertEquality(a1, <string[2]>["book1", "book2"]);
    io:println(a1); // @output ["book1","book2"]
    string a2 = myClient->/books/[1];
    assertEquality(a2, "book1");
    io:println(a2); // @output book1
    string a3 = myClient->/books/[1].get;
    assertEquality(a3, "book1");
    io:println(a3); // @output book1
    int bookId = 2;
    string a4 = myClient->/books/[bookId];
    assertEquality(a4, "book2");
    io:println(a4); // @output book2
    string b1 = myClient->/books/book1/[1.5];
    assertEquality(b1, "book1.1.5");
    io:println(b1); // @output book1.1.5
    string b2 = myClient->/books/book1/[5];
    assertEquality(b2, "book1.5.0");
    io:println(b2); // @output book1.5.0
    string b3 = myClient->/books/book1/[1.5].get;
    assertEquality(b3, "book1.1.5");
    io:println(b3); // @output book1.1.5
    float volume = 2;
    string b4 = myClient->/books/book1/[volume];
    assertEquality(b4, "book1.2.0");
    io:println(b4); // @output book1.2.0
    string book1 = "book1";
    string c1 = myClient->/books/[book1]/[1.5].post;
    assertEquality(c1, "book1.1.5");
    io:println(c1); // @output book1.1.5
    string c2 = myClient->/books/book1/[5].post;
    assertEquality(c2, "book1.5");
    io:println(c2); // @output book1.5
    string c3 = myClient->/books/book1/[1.5].post;
    assertEquality(c3, "book1.1.5");
    io:println(c3); // @output book1.1.5
    decimal volume2 = 2;
    string c4 = myClient->/books/[book1]/[volume2].post;
    assertEquality(c4, "book1.2");
    io:println(c4); // @output book1.2
    boolean d1 = myClient->/[true];
    assertEquality(d1, true);
    io:println(d1); // @output true
    boolean flag = false;
    true boolVal = true;
    boolean d2 = myClient->/[flag];
    assertEquality(d2, false);
    io:println(d2); // @output false
    boolean d3 = myClient->/[boolVal];
    assertEquality(d3, true);
    io:println(d3); // @output true
}

const PATH = "someLongPathSegment";

type X "x";

client class MyClient3 {
    resource function get books/[PATH]() returns int {
        return 1;
    }

    resource function post books/[X]() returns int {
        return 2;
    }

    resource function put books/[PATH](int a) returns int {
        return a;
    }

    resource function someOtherMethod books/[PATH...](int a) returns int {
        return a;
    }
}

function testConstantAndUserDefinedTypesInResourcePathWithoutVarName() {
    MyClient3 myClient = new;
    "someLongPathSegment" path = "someLongPathSegment";

    int a1 = myClient->/books/someLongPathSegment;
    assertEquality(a1, 1);
    io:println(a1); // @output 1
    int a11 = myClient->/books/someLongPathSegment.put(3);
    assertEquality(a11, 3);
    io:println(a11); // @output 3
    int a12 = myClient->/books/someLongPathSegment.someOtherMethod(2);
    assertEquality(a12, 2);
    io:println(a12); // @output 2
    int a2 = myClient->/books/[PATH];
    assertEquality(a2, 1);
    io:println(a2); // @output 1
    int a3 = myClient->/books/[path];
    assertEquality(a3, 1);
    io:println(a3); // @output 1
    int b1 = myClient->/books/x.post;
    assertEquality(b1, 2);
    io:println(b1); // @output 2
    int b2 = myClient->/books/["x"].post;
    assertEquality(b2, 2);
    io:println(b2); // @output 2
    "x" x = "x";
    int b3 = myClient->/books/[x].post;
    assertEquality(b3, 2);
    io:println(b3); // @output 2
}

client class MyClient4 {
    resource function get books/[string... a]() returns string[] {
        return a;
    }

    resource function get [int a]/[int... b]() returns int[] {
        return b;
    }

    resource function post [int a]/[int b]() returns int {
        return b;
    }

    resource function post books/["books"... a]() returns string[] {
        return a;
    }

    resource function put books/["books" a]() returns string {
        return a;
    }

    resource function someOtherMethod books/["books" a]/["books"... b]() returns string[] {
        return b;
    }

    resource function someOtherMethod2 books/books/["books" a]/["books"... b]() returns string[] {
        return b;
    }

    resource function someOtherMethod3 books/books/["books"... b]() returns string[] {
        return b;
    }

    resource function post game/[string name]/[int players]() returns string {
        return name + ": " + players.toString();
    }

    resource function post game/[string name]/path/[int players]() returns string {
        return name + ": " + players.toString();
    }

    resource function post games/game/[string name]/[int players]() returns string {
        return name + ": " + players.toString();
    }
}

function testWithResourceAccessRestSegment() {
    MyClient4 myClient = new;

    string[] a1 = myClient->/books/someLongPathSegment;
    assertEquality(a1, <string[]>["someLongPathSegment"]);
    io:println(a1); // @output ["someLongPathSegment"]
    string[] a2 = myClient->/books;
    assertEquality(a2, <string[]>[]);
    io:println(a2); // @output []
    string[] a3 = myClient->/books/path/morePathSegments/morePathSegments;
    assertEquality(a3, <string[]>["path", "morePathSegments", "morePathSegments"]);
    io:println(a3); // @output ["path","morePathSegments","morePathSegments"]
    string[] a4 = myClient->/books/path/["morePathSegments"]/morePathSegments;
    assertEquality(a4, <string[]>["path", "morePathSegments", "morePathSegments"]);
    io:println(a4); // @output ["path","morePathSegments","morePathSegments"]
    string[] pathSegArray = ["path1", "path2"];
    [string] pathSegTuple = ["path1"];
    string[] b1 = myClient->/books/path/[...pathSegArray];
    assertEquality(b1, <string[]>["path", "path1", "path2"]);
    io:println(b1); // @output ["path","path1","path2"]
    string[] b11 = myClient->/books/path/[...pathSegTuple];
    assertEquality(b11, <string[]>["path", "path1"]);
    io:println(b11); // @output ["path","path1"]
    string[] b2 = myClient->/books/path/[...["path1", "path2"]];
    assertEquality(b2, <string[]>["path", "path1", "path2"]);
    io:println(b2); // @output ["path","path1","path2"]
    int[3] intArray = [1, 2, 3];
    [int, int] intTuple = [1, 2];

    int[] b3 = myClient->/[...intArray];
    assertEquality(b3, <int[]>[2, 3]);
    io:println(b3); // @output [2,3]
    int[] b4 = myClient->/[...[1, 2, 3]];
    assertEquality(b4, <int[]>[2, 3]);
    io:println(b4); // @output [2,3]
    int[] b5 = myClient->/[...intTuple];
    assertEquality(b5, <int[]>[2]);
    io:println(b5); // @output [2]
    int[] b51 = myClient->/[1];
    assertEquality(b51, <int[]>[]);
    io:println(b51); // @output []
    int[] b52 = myClient->/[1]/[2]/[3]/[4]/[5];
    assertEquality(b52, <int[]>[2, 3, 4, 5]);
    io:println(b52); // @output [2,3,4,5]
    int b6 = myClient->/[...intTuple].post;
    assertEquality(b6, 2);
    io:println(b6); // @output 2
    "books"[2] booksArray = ["books", "books"];
    string[] b7 = myClient->/[...booksArray].post;
    assertEquality(b7, <"books"[]>["books"]);
    io:println(b7); // @output ["books"]
    string b8 = myClient->/[...booksArray].put;
    assertEquality(b8, "books");
    io:println(b8); // @output books
    string[] b9 = myClient->/[...booksArray].someOtherMethod;
    assertEquality(b9, <"books"[]>[]);
    io:println(b9); // @output []
    "books"[4] booksArray2 = ["books", "books", "books", "books"];
    string[] b10 = myClient->/[...booksArray2].someOtherMethod;
    assertEquality(b10, <"books"[]>["books", "books"]);
    io:println(b10); // @output ["books","books"]
    string[] b12 = myClient->/[...booksArray2].someOtherMethod2;
    assertEquality(b12, <"books"[]>["books"]);
    io:println(b12); // @output ["books"]
    string[] b13 = myClient->/[...booksArray2].someOtherMethod3;
    assertEquality(b13, <"books"[]>["books", "books"]);
    io:println(b13); // @output ["books","books"]
    [string, int] gameDetails = ["Chess", 2];
    string b14 = myClient->/game/[...gameDetails].post;
    assertEquality(b14, "Chess: 2");
    io:println(b14); // @output Chess: 2
    [string, "path", int] gameDetails2 = ["Carrom", "path", 4];
    string b15 = myClient->/game/[...gameDetails2].post;
    assertEquality(b15, "Carrom: 4");
    io:println(b15); // @output Carrom: 4
    string b16 = myClient->/games/game/[...gameDetails].post;
    assertEquality(b16, "Chess: 2");
    io:println(b16); // @output Chess: 2
}

client class MyClient5 {
    resource function get [string... a](string... b) returns string[][] {
        return [a, b];
    }

    resource function get1 [string](int a, int b) returns int {
        return a;
    }

    resource function get path/[int a]/path2/[string](string b, int... c) returns [int, string, int[]] {
        return [a, b, c];
    }

    resource function put [int](int a, int b = 5) returns int[2] {
        return [a, b];
    }
}

function testResourceAccessWithArguments() {
    MyClient5 myClinet = new;

    string[][] a1 = myClinet->/;
    assertEquality(a1, <string[][]>[[], []]);
    io:println(a1); // @output [[],[]]
    string[][] a2 = myClinet->/books/books2;
    assertEquality(a2, <string[][]>[["books", "books2"], []]);
    io:println(a2); // @output [["books","books2"],[]]
    string[][] a3 = myClinet->/("books", "pen");
    assertEquality(a3, <string[][]>[[], ["books", "pen"]]);
    io:println(a3); // @output [[],["books","pen"]]
    string[][] a4 = myClinet->/a/b/c("d", "e");
    assertEquality(a4, <string[][]>[["a", "b", "c"], ["d", "e"]]);
    io:println(a4); // @output [["a","b","c"],["d","e"]]
    string[][] a41 = myClinet->/["a"]/[...["b", "c"]](...["d", "e"]);
    assertEquality(a41, <string[][]>[["a", "b", "c"], ["d", "e"]]);
    io:println(a41); // @output [["a","b","c"],["d","e"]]
    int a5 = myClinet->/a.get1(5, 6);
    assertEquality(a5, 5);
    io:println(a5); // @output 5
    string a = "a";
    int a6 = myClinet->/[a].get1(4, 6);
    assertEquality(a6, 4);
    io:println(a6); // @output 4
    int a7 = myClinet->/[...["car"]].get1(3, 6);
    assertEquality(a7, 3);
    io:println(a7); // @output 3
    [int, string, int[]] a8 = myClinet->/path/[1]/path2/path3("book", 6);
    assertEquality(a8, <[int, string, int[]]>[1, "book", [6]]);
    io:println(a8); // @output [1,"book",[6]]
    "path2"[2] pathArray = ["path2", "path2"];
    [int, string, int[]] a9 = myClinet->/path/[1]/[...pathArray]("book", 6);
    assertEquality(a9, <[int, string, int[]]>[1, "book", [6]]);
    io:println(a9); // @output [1,"book",[6]]
    int[2] a10 = myClinet->/[5].put(1, 6);
    assertEquality(a10, <int[2]>[1, 6]);
    io:println(a10); // @output [1,6]
    int[2] a11 = myClinet->/[5].put(1);
    assertEquality(a11, <int[2]>[1, 5]);
    io:println(a11); // @output [1,5]
}

client class MyClient6 {
    resource function get [string... a](string... b) returns string[][] {
        return [a, b];
    }

    resource function get1 [string](int a, int b) returns int? {
        return a;
    }

    resource function get path/[int a]/path2/[string](string b, int... c) returns [int, string, int[]] {
        return [a, b, c];
    }

    resource function put [int](int a, int b = 5) returns int[2] {
        return [a, b];
    }

    resource function get path/[boolean a](string b) returns boolean|xml {
        return a;
    }

    resource function get [float a](string b) returns float|map<int> {
        return a;
    }

    resource function get [decimal a]/path(string b) returns decimal {
        return a;
    }
}

function testStaticTypeOfClientResourceAccessAction() {
    MyClient6 myClinet = new;

    var a1 = myClinet->/;
    string[][] a01 = a1;
    assertEquality(a01, <string[][]>[[], []]);
    io:println(a01); // @output [[],[]]
    var a2 = myClinet->/books/books2;
    string[][] a02 = a2;
    assertEquality(a02, <string[][]>[["books", "books2"], []]);
    io:println(a02); // @output [["books","books2"],[]]
    var a3 = myClinet->/("books", "pen");
    string[][] a03 = a3;
    assertEquality(a03, <string[][]>[[], ["books", "pen"]]);
    io:println(a03); // @output [[],["books","pen"]]
    var a5 = myClinet->/a.get1(5, 6);
    int? a05 = a5;
    assertEquality(a05, 5);
    io:println(a05); // @output 5
    var a7 = myClinet->/[...["car"]].get1(3, 6);
    int? a07 = a7;
    assertEquality(a07, 3);
    io:println(a07); // @output 3
    var a8 = myClinet->/path/[1]/path2/path3("book", 6);
    [int, string, int[]] a08 = a8;
    assertEquality(a08, <[int, string, int[]]>[1, "book", [6]]);
    io:println(a08); // @output [1,"book",[6]]
    var a10 = myClinet->/[5].put(1, 6);
    int[2] a010 = a10;
    assertEquality(a010, <int[2]>[1, 6]);
    io:println(a010); // @output [1,6]
    var a11 = myClinet->/[5].put(1);
    int[2] a011 = a11;
    assertEquality(a011, <int[2]>[1, 5]);
    io:println(a011); // @output [1,5]
    var a12 = myClinet->/path/[true]("car");
    boolean|xml a012 = a12;
    assertEquality(a012, true);
    io:println(a012); // @output true
    var a13 = myClinet->/[1.45]("car");
    float|map<int> a013 = a13;
    assertEquality(a013, 1.45);
    io:println(a013); // @output 1.45
    var a14 = myClinet->/[1.0003]/path("car");
    decimal a014 = a14;
    assertEquality(a014, 1.0003d);
    io:println(a014); // @output 1.0003
}

function testResourceAccessOfAnObjectConstructedViaObjectCons() {
    var myClinet = client object {
        resource function get [string... a](string... b) returns string[][] {
            return [a, b];
        }

        resource function get1 [string](int a, int b) returns int {
            return a;
        }

        resource function get path/[int a]/path2/[string](string b, int... c) returns [int, string, int[]] {
            return [a, b, c];
        }

        resource function put [int](int a, int b = 5) returns int[2] {
            return [a, b];
        }

        resource function put [PATH]/path(int a) returns int {
            return a;
        }
    };

    string[][] a1 = myClinet->/;
    assertEquality(a1, <string[][]>[[], []]);
    io:println(a1); // @output [[],[]]
    string[][] a2 = myClinet->/books/books2;
    assertEquality(a2, <string[][]>[["books", "books2"], []]);
    io:println(a2); // @output [["books","books2"],[]]
    string[][] a3 = myClinet->/("books", "pen");
    assertEquality(a3, <string[][]>[[], ["books", "pen"]]);
    io:println(a3); // @output [[],["books","pen"]]
    string[][] a41 = myClinet->/["a"]/[...["b", "c"]](...["d", "e"]);
    assertEquality(a41, <string[][]>[["a", "b", "c"], ["d", "e"]]);
    io:println(a41); // @output [["a","b","c"],["d","e"]]
    int a5 = myClinet->/a.get1(5, 6);
    assertEquality(a5, 5);
    io:println(a5); // @output 5
    int a7 = myClinet->/[...["car"]].get1(3, 6);
    assertEquality(a7, 3);
    io:println(a7); // @output 3
    [int, string, int[]] a8 = myClinet->/path/[1]/path2/path3("book", 6);
    assertEquality(a8, <[int, string, int[]]>[1, "book", [6]]);
    io:println(a8); // @output [1,"book",[6]]
    "path2"[2] pathArray = ["path2", "path2"];
    [int, string, int[]] a9 = myClinet->/path/[1]/[...pathArray]("book", 6);
    assertEquality(a9, <[int, string, int[]]>[1, "book", [6]]);
    io:println(a9); // @output [1,"book",[6]]
    int[2] a10 = myClinet->/[5].put(1, 6);
    assertEquality(a10, <int[2]>[1, 6]);
    io:println(a10); // @output [1,6]
    int[2] a11 = myClinet->/[5].put(1);
    assertEquality(a11, <int[2]>[1, 5]);
    io:println(a11); // @output [1,5]
    int a12 = myClinet->/[PATH]/path.put(4);
    assertEquality(a12, 4);
    io:println(a12); // @output 4
}

client class MyClient7 {
    resource isolated function get customers\-json() returns string {
        return "response1";
    }

    resource isolated function get '955() returns string {
        return "response2";
    }

    resource isolated function get A\u{0042}() returns string {
        return "response3";
    }

    resource isolated function post AB() returns string {
        return "response4";
    }
}

function testResourceAccessContainingSpecialChars() {
    MyClient7 myClient = new;

    string a = myClient->/customers\-json;
    assertEquality(a, "response1");
    io:println(a); // @output response1
    string b = myClient->/'customers\-json;
    assertEquality(b, "response1");
    io:println(b); // @output response1
    string c = myClient->/'955;
    assertEquality(c, "response2");
    io:println(c); // @output response2
    string d = myClient->/A\u{0042};
    assertEquality(d, "response3");
    io:println(d); // @output response3
    string e = myClient->/AB;
    assertEquality(e, "response3");
    io:println(e); // @output response3
    string f = myClient->/A\u{0042}.post;
    assertEquality(f, "response4");
    io:println(f); // @output response4
}

client class MyClient9 {
    int flags = 10;
    resource function get closureTest1(string status) returns string {
        var addFunc = function(int funcInt) returns string {
            return status;
        };
        return addFunc(1);
    }

    resource function get closureTest2/[int a]/path() returns int {
        var addFunc = function() returns int {
            return a;
        };
        return addFunc();
    }

    resource function post closureTest2/[int a]/path() returns int {
        var addFunc = function() returns int {
            return a + self.flags;
        };
        return addFunc();
    }

    resource function get closureTest3/[int... a]() returns int[] {
        var addFunc = function() returns int[] {
            return a;
        };
        return addFunc();
    }

    resource function get [string path]/closureTest4() returns string {
        var addFunc = function(int funcInt) returns string {
            return path;
        };
        return addFunc(1);
    }
}

function testClosuresFromPathParams() {
    MyClient9 myClient = new;

    string a = myClient->/closureTest1("status1");
    assertEquality(a, "status1");
    io:println(a); // @output status1
    int|string b = myClient->/closureTest2/[2]/path;
    assertEquality(b, 2);
    io:println(b); // @output 2
    int intVar = 2;
    int[] c = myClient->/closureTest3/[1]/[intVar];
    assertEquality(c, <int[]>[1, 2]);
    io:println(c); // @output [1,2]
    string d = myClient->/test/closureTest4;
    assertEquality(d, "test");
    io:println(d); // @output test
    int e = myClient->/closureTest2/[2]/path.post;
    assertEquality(e, 12);
    io:println(e); // @output 12
}

public type Params record {|
    never headers?;
    int...;
|};

client class MyClient10 {
    resource function get [string... path](string? headers = (), *Params params) returns int {
        if headers == () {
            return params.get("id");
        }

        return params.get("id") + headers.length();
    }

    resource function post foo/[int a]/bar(*Params params) returns int {
        return params.get("id") + a;
    }
}

function testAccessingResourceWithIncludedRecordParam() {
    MyClient10 cl = new;
    int a = cl->/foo/bar(id = 1);
    assertEquality(a, 1);
    io:println(a); // @output 1
    int a1 = cl->/foo/bar(headers = "Ballerina", id = 2);
    assertEquality(a1, 11);
    io:println(a1); // @output 11
    int b = cl->/foo/[4]/bar.post(id = 1);
    assertEquality(b, 5);
    io:println(b); // @output 5
    Params recVal = {"id": 2};
    int c = cl->/foo/[10]/bar.post(recVal);
    assertEquality(c, 12);
    io:println(c); // @output 12
    int d = cl->/foo/[1]/bar.post(params = recVal);
    assertEquality(d, 3);
    io:println(d); // @output 3
}

client class Client11 {
    resource function get v1\.2/greeting1() returns string {
        return "Path1";
    }

    resource function get ["v1.2"]/greeting2() returns string {
        return "Path2";
    }

    resource function get v1\.2/ab\.c/greeting3() returns string {
        return "Path3";
    }

    resource function get v1\.\.2() returns string {
        return "Path4";
    }

    function abc\.abc() returns string {
        return "abc.abc";
    }
}

function testAccessingResourceWithEscapedChars() {
    Client11 cl = new;
    string a1 = cl->/v1\.2/greeting1;
    assertEquality(a1, "Path1");
    io:println(a1); // @output Path1
    string a2 = cl->/["v1.2"]/greeting1;
    assertEquality(a2, "Path1");
    io:println(a2); // @output Path1
    string b1 = cl->/["v1.2"]/greeting2;
    assertEquality(b1, "Path2");
    io:println(b1); // @output Path2
    string b2 = cl->/v1\.2/greeting2;
    assertEquality(b2, "Path2");
    io:println(b2); // @output Path2
    string c1 = cl->/v1\.2/ab\.c/greeting3;
    assertEquality(c1, "Path3");
    io:println(c1); // @output Path3
    string c2 = cl->/["v1.2"]/["ab.c"]/greeting3;
    assertEquality(c2, "Path3");
    io:println(c2); // @output Path3
    string d1 = cl->/v1\.\.2;
    assertEquality(d1, "Path4");
    io:println(d1); // @output Path4
    string e1 = cl.abc\.abc();
    assertEquality(e1, "abc.abc");
    io:println(e1); // @output abc.abc
}

client class MyClient8 {
    resource isolated function get .() returns string {
        return "response1";
    }

    resource isolated function get A\u{0042}() returns int|string {
        return "response3";
    }

    resource isolated function post AB/[string a]() returns string {
        return a;
    }
}

function testAccessingDeprecatedResource() {
    MyClient8 myClient = new;

    string a = myClient->/;
    assertEquality(a, "response1");
    io:println(a); // @output response1
    int|string b = myClient->/AB;
    assertEquality(b, "response3");
    io:println(b); // @output response3
    string c = myClient->/AB/[PATH].post;
    assertEquality(c, "someLongPathSegment");
    io:println(c); // @output someLongPathSegment
}

public function main() {
    testBasicClientResourceAccess();
    testClientResourceAccessContainingComputedResourceAccessSegments();
    testConstantAndUserDefinedTypesInResourcePathWithoutVarName();
    testWithResourceAccessRestSegment();
    testResourceAccessWithArguments();
    testStaticTypeOfClientResourceAccessAction();
    testResourceAccessOfAnObjectConstructedViaObjectCons();
    testResourceAccessContainingSpecialChars();
    testClosuresFromPathParams();
    testAccessingResourceWithIncludedRecordParam();
    testAccessingResourceWithEscapedChars();
    testAccessingDeprecatedResource();
}

function assertEquality(any|error actual, any|error expected) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }

    if expected === actual {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error("AssertionError",
            message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.

import ballerina/io;

public function basicWorkerTest() returns int {
    int i = 10;
    @strand{thread:"any"}
    worker w1 {
        i = i + 40;
        i -> w2;
    }

    @strand{thread:"any"}
    worker w2 returns int {
        int j = 25;
        j = <- w1;
        i = j;
        return j;
    }

    _ = wait {w1, w2};
    return i;
}

public function testWithTuples() returns [string, int] {
    string str = "Hello Ballerina!!!";
    int i = 10;
    @strand{thread:"any"}
    worker w1 {
        str = "Changed inside worker 1!!!";
        i = i + 40;
        i -> w2;
    }

    @strand{thread:"any"}
    worker w2 returns int {
        int j = <- w1;
        i = 100 + i;
        str = str + " -- Changed inside worker 2!!!";
        return i;
    }

    _ = wait {w1, w2};
    return [str, i];
}

const TOKEN = "token";

public function testWithMaps() returns map<string> {
    map<string> m1 = {a: "A", b: "B", c: "C", d: "D"};
    @strand{thread:"any"}
    worker w1 {
        m1["e"] = "EE";
        m1["a"] = "AA";
        TOKEN -> w3;
    }

    @strand{thread:"any"}
    worker w2 {
        m1["a"] = "AAA";
        m1["n"] = "N";
        TOKEN -> w3;
    }

    @strand{thread:"any"}
    worker w3 {
        _ = <- w1;
        _ = <- w2;
        m1["e"] = "EEE";
        m1["a"] = "AAAA";
    }

    _ = wait {w1, w2, w3};
    m1["x"] = "X";
    return m1;
}

public function complexWorkerTest() returns [int, map<string>] {
    int i = 5;
    map<string> m1 = {a: "A", b: "B", c: "C", d: "D"};

    @strand{thread:"any"}
    worker w1 {
        m1["e"] = "EE";
        m1["a"] = "AA";

        fork {
            worker w4 {
                int j = 100 * 2;
                i = j;
                m1["b"] = "BB";

                i = i + 50;
                m1["m"] = "M";
                fork {
                    worker w6 {
                        i = i + 100;
                        m1["m"] = "MMM";
                        m1["a"] = "AAAA";
                    }
                }
                _ = wait w6;
            }
        }
        _ = wait w4;
    }
    _ = wait w1;

    i = i + 50;
    m1["b"] = "BBBB";
    return [i, m1];
}

public type Student record {|
    string name;
    int age;
    string email?;
    string...;
|};

public function testWithRecords() returns Student {
    Student stu = {name: "John Doe", age: 17};
    @strand{thread:"any"}
    worker w1 {
        stu.name = "Adam Page";
    }

    @strand{thread:"any"}
    worker w2 {
        stu = {name: "Adam Page", age: 24};
        stu.email = "adamp@gmail.com";
    }

    var f = function () {
        wait w2;
        stu.email = "adamp@wso2.com";
    };
    var fw = @strand{thread:"any"} start f();
    record {| error? w1; error? fw; |} ignore = wait {w1, fw};
    return stu;
}

public class Person {
    public int age;
    public string name;
    public string fullName;

    function init(int age, string name, string fullName) {
        self.age = age;
        self.name = name;
        self.fullName = fullName;
    }
}

public function testWithObjects() returns Person {
    Person p1 = new(5, "John", "John Doe");
    @strand{thread:"any"}
    worker w1 {
        p1.age = 10;
        p1.name = "Joe";
    }

    @strand{thread:"any"}
    worker w2 {
        p1.age = 25;
    }

    var f = function () {
        _ = wait {w1, w2};
        p1 = new(40, "Adam", "Adam Adam Page");
    };
    future<()> w3 = @strand{thread:"any"} start f();

    error? ignore = wait w3;
    return p1;
}

public function main() {
    int basic = basicWorkerTest();
    io:println(basic); // @output 50

    [string, int] tupleResult = testWithTuples();
    io:println(tupleResult.length()); // @output 2
    io:println(tupleResult[0]); // @output Changed inside worker 1!!! -- Changed inside worker 2!!!
    io:println(tupleResult[1]); // @output 150

    map<string> mapResult = testWithMaps();
    io:println(mapResult.length()); // @output 7
    io:println(mapResult["a"]); // @output AAAA
    io:println(mapResult["b"]); // @output B
    io:println(mapResult["c"]); // @output C
    io:println(mapResult["d"]); // @output D
    io:println(mapResult["e"]); // @output EEE
    io:println(mapResult["x"]); // @output X
    io:println(mapResult["n"]); // @output N

    [int, map<string>] complexResult = complexWorkerTest();
    io:println(complexResult.length()); // @output 2
    io:println(complexResult[0]); // @output 400
    map<string> complexMap = complexResult[1];
    io:println(complexMap.length()); // @output 6
    io:println(complexMap["a"]); // @output AAAA
    io:println(complexMap["b"]); // @output BBBB
    io:println(complexMap["c"]); // @output C
    io:println(complexMap["d"]); // @output D
    io:println(complexMap["e"]); // @output EE
    io:println(complexMap["m"]); // @output MMM

    Student recordResult = testWithRecords();
    io:println(recordResult.length()); // @output 3
    io:println(recordResult); // @output {"name":"Adam Page","age":24,"email":"adamp@wso2.com"}

    Person objectResult = testWithObjects();
    io:println("{age:" + objectResult.age.toString() + ", name:" + objectResult.name + ", fullName:" +
        objectResult.fullName + "}"); // @output {age:40, name:Adam, fullName:Adam Adam Page}
}

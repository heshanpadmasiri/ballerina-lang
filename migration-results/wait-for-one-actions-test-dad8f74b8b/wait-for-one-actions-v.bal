import ballerina/io;
import ballerina/lang.runtime;

function waitTest1() returns int {
    future<int> f1 = @strand {thread: "any"} start add(5, 2);
    int result = checkpanic wait f1;
    return result;
}

function waitTest2() returns boolean {
    future<boolean> f6 = @strand {thread: "any"} start status();
    boolean result = checkpanic wait f6;
    return result;
}

function waitTest3() returns any {
    future<string> f4 = @strand {thread: "any"} start concat("foo");
    any result = checkpanic wait f4;
    return result;
}

function waitTest4() returns any[] {
    future<int> f2 = @strand {thread: "any"} start add(10, 12);
    future<string> f5 = @strand {thread: "any"} start concat("bar");
    future<int|string> f7 = @strand {thread: "any"} start concat("xyz");

    int|string result1 = checkpanic wait f2;
    int|string result2 = checkpanic wait f5;
    int|string result3 = checkpanic wait f7;

    any[] arr = [];
    arr[0] = result1;
    arr[1] = result2;
    arr[2] = result3;
    return arr;
}

function waitTest5() returns map<string> {
    future<map<string>> f9 = @strand {thread: "any"} start getEmpMap();
    map<string> m = checkpanic wait f9;
    return m;
}

function waitTest6() returns int|float {
    future<int|float> f8 = @strand {thread: "any"} start add(66, 33);
    int|float result = checkpanic wait f8;
    return result;
}

function waitTest7() returns int {
    int result = checkpanic wait fuInt();
    return result;
}

function waitTest9() returns () {
    future<()> f1 = start runtime:sleep(2.0);
    () result = wait f1;
    return result;
}

function add(int i, int j) returns int {
    return i + j;
}

function concat(string name) returns string {
    return "hello " + name;
}

function status() returns boolean {
    return true;
}

function fuInt() returns future<int> {
    future<int> i = @strand {thread: "any"} start add(11, 55);
    return i;
}

function getEmpMap() returns map<string> {
    return {fname: "foo", lname: "bar"};
}

class Student {
    public string name;

    public function init() {
        future<int> _ = start add(2, 4);
        self.name = "ABC";
    }
}

function asyncObjectCreationTest() {
    Student s = new();
    Student[] arr = [];
    arr[0] = s;
    arr[2] = s;
}

public function main() {
    io:println(waitTest1()); // @output 7
    io:println(waitTest2()); // @output true
    io:println(waitTest3()); // @output hello foo
    any[] waitTest4Result = waitTest4();
    io:println(waitTest4Result.length()); // @output 3
    io:println(waitTest4Result[0]); // @output 22
    io:println(waitTest4Result[1]); // @output hello bar
    io:println(waitTest4Result[2]); // @output hello xyz
    io:println(waitTest5()); // @output {"fname":"foo","lname":"bar"}
    io:println(waitTest6()); // @output 99
    io:println(waitTest7()); // @output 66
    io:println(waitTest9()); // @output
    asyncObjectCreationTest();
}

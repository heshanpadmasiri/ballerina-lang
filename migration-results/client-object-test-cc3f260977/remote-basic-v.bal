import ballerina/io;

client class TestEP {
    remote function action1(string s, int i) returns boolean {
        if i > 5 {
            return true;
        }
        return false;
    }

    remote function action2(string s, boolean b) returns int {
        return 10;
    }

    function func1(string s) {
    }

    function func2(string s) returns int {
        return 5;
    }
}

function test1(int i) returns boolean {
    TestEP z;
    TestEP x = new;
    TestEP y = new;
    x.func1("abc");
    boolean b = x->action1("test1", i);
    return b;
}

function test2() returns int {
    TestEP x = new;
    return x.func2("test");
}

TestEP globEP = new;

class TestObject {
    string s = "abc";
    TestEP x = new;

    function test() returns boolean {
        _ = globEP->action1("test1", 10);
        boolean b = self.x->action1("test1", 10);
        return b;
    }
}

function test3() returns boolean {
    TestObject x = new;
    return x.test();
}

function clientObjectDeclaredInLoop() returns int {
    foreach var index in 1...3 {
        TestEP x = new;
        if 4 - 2 == 2 {
            return x->action2("0", false);
        }
    }
    return 0;
}

function clientObjectDeclaredInIfStatement() returns int {
    if 4 - 2 == 2 {
        TestEP x = new;
        return x->action2("0", false);
    }
    return 0;
}

function clientObjectDeclaredInIfStatementElseBlock() returns int {
    if 4 - 2 == 0 {
        return 0;
    } else {
        int i = 0;
        int j = 100;
        int k = i + j;
        TestEP x = new;
        return x->action2("0", false);
    }
}

public function main() {
    io:println(test1(4)); // @output false
    io:println(test1(10)); // @output true
    io:println(test2()); // @output 5
    io:println(clientObjectDeclaredInLoop()); // @output 10
    io:println(clientObjectDeclaredInIfStatement()); // @output 10
    io:println(clientObjectDeclaredInIfStatementElseBlock()); // @output 10
}

import ballerina/test;

class TestClass {
    *Obj;
    int i;

    function init() {
        self.i = 21;
    }

    function foo() returns boolean => true;
}

@test:Config { enable: false }
function testClassMemberVisibility() {
    TestClass tc = new;
    test:assertTrue(tc.foo());
    test:assertTrue(tc.i == 22);
}

@test:Config { enable: false }
function testRecordVisibility() {
    Rec rec = {s: "test string"};
    test:assertEquals(rec.s, "test string");
}
